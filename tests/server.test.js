const request = require("supertest");
const app = require("../src/server");

describe("API Tests", () => {
  test("GET /greet/:name returns greeting", async () => {
    const res = await request(app).get("/greet/Tester");

    expect(res.statusCode).toBe(200);
    expect(res.body.message).toBe("Hello, Tester");
  });

  test("GET /health returns status ok", async () => {
    const res = await request(app).get("/health");

    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe("ok");
  });
});
