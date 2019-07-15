// https://www.graphile.org/postgraphile/testing-jest/

import { Pool } from "pg";

const pools = {};

// Make sure we release those pgPools so that our tests exit!
afterAll(() => {
  const keys = Object.keys(pools);
  return Promise.all(
    keys.map(async key => {
      try {
        const pool = pools[key];
        delete pools[key];
        await pool.end();
      } catch (e) {
        console.error("Failed to release connection!");
        console.error(e);
      }
    })
  );
});

const withDbFromUrl = async (url, fn) => {
  if (!pools[url]) {
    pools[url] = new Pool({ connectionString: url });
  }
  const pool = pools[url];
  const client = await pool.connect();
  await client.query("BEGIN ISOLATION LEVEL SERIALIZABLE;");

  try {
    await fn(client);
  } catch (e) {
    // Error logging can be helpful:
    if (typeof e.code === "string" && e.code.match(/^[0-9A-Z]{5}$/)) {
      console.error([e.message, e.code, e.detail, e.hint, e.where].join("\n"));
    }
    throw e;
  } finally {
    await client.query("ROLLBACK;");
    await client.query("RESET ALL;"); // Shouldn't be necessary, but just in case...
    await client.release();
  }
};

export const withRootDb = fn =>
  withDbFromUrl(process.env.TEST_DATABASE_URL, fn);


exports.findUser = async (client, username) => {
  const result = await client.query(
    "select * from auth.app_user where username = $1",
    [username]
  );
  return result.rows[0]
}

exports.becomeUser = (client, userInfo) =>
  client.query(
    "select set_config('role', $1, true), set_config('jwt.claims.user_id', $2, true);",
    [userInfo.role, userInfo.id]
  );
  // client.query(
  //   "select set_config('role', $1, true), set_config('jwt.claims.user_id', $2, true);",
  //   ["app_visitor", userOrUserId ? userOrUserId.id || userOrUserId : null]
  // );
