import express from "express";

const app = express();
const PORT = process.env.PORT || 8080;

app.get("/greet/:name", (req, res) => {
  const { name } = req.params;
  res.json({ message: `Hello, ${name}` });
});

app.get("/health", async (req, res) => {
  const start = Date.now();

  try {
    // Simulate a basic internal check
    await Promise.resolve();

    const latency = Date.now() - start;
    res.json({
      status: "ok",
      latencyMs: latency
    });
  } catch (error) {
    res.status(500).json({
      status: "unreachable",
      message: "Server is experiencing issues",
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});