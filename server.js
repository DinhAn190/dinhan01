import express from "express";
import pkg from "pg";
import cors from "cors";

const { Pool } = pkg;
const app = express();
app.use(cors());
app.use(express.json());

// 🔑 Connection string của Render PostgreSQL
const pool = new Pool({
  connectionString:
    "postgresql://expense_db_l47n_user:9LO8PACSTJMsmu1B2kb9knyiGhpaIB1A@dpg-d34mbg95pdvs73e2f3b0-a.oregon-postgres.render.com:5432/expense_db_l47n?sslmode=require",
});

// ✅ Test kết nối
pool.connect()
  .then(() => console.log("✅ Connected to Render PostgreSQL"))
  .catch((err) => console.error("❌ Database connection error:", err));

// ---------------- API ---------------- //

// Lấy toàn bộ transactions
app.get("/transactions", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM transactions ORDER BY id DESC");
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch transactions" });
  }
});

// Thêm transaction mới
app.post("/transactions", async (req, res) => {
  try {
    const { title, amount, is_income, date } = req.body;
    const result = await pool.query(
      "INSERT INTO transactions (title, amount, is_income, date) VALUES ($1, $2, $3, $4) RETURNING *",
      [title, amount, is_income, date]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to add transaction" });
  }
});

// Xóa transaction
app.delete("/transactions/:id", async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query("DELETE FROM transactions WHERE id = $1", [id]);
    res.json({ message: "Transaction deleted" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to delete transaction" });
  }
});

// ---------------- RUN SERVER ---------------- //
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
