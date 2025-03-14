const express = require("express");
const cors = require("cors");
const mysql = require("mysql2");

// Inisialisasi aplikasi Express
const app = express();

// Middleware untuk parsing JSON
app.use(express.json());

// Izinkan request dari domain lain
app.use(
  cors({
    origin: "http://localhost:5500", // Ganti dengan URL Flutter di Chrome
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "", // Password MySQL (kosong untuk Laragon default)
  database: "db_cart", // Nama database yang dibuat di Laragon
});

// Periksa koneksi database
db.connect((err) => {
  if (err) {
    console.error("Koneksi database gagal:", err);
  } else {
    console.log("Terhubung ke database MySQL");
  }
});

app.post("/register", (req, res) => {
  const { firstName, lastName, username, email, phone, password } = req.body;

  // Validasi input
  if (!firstName || !lastName || !username || !email || !phone || !password) {
    return res.status(400).json({ error: "Semua field harus diisi" });
  }

  // Query untuk menambahkan user baru
  const query = `
    INSERT INTO users (first_name, last_name, username, email, phone, password)
    VALUES (?, ?, ?, ?, ?, ?)
  `;
  const values = [firstName, lastName, username, email, phone, password];

  db.query(query, values, (err, result) => {
    if (err) {
      console.error("Error saat registrasi:", err);
      return res.status(500).json({ error: "Terjadi kesalahan saat registrasi", details: err.message });
    }

    // Kirim respons sukses
    res.status(201).json({ message: "User berhasil terdaftar", userId: result.insertId });
  });
});

// Endpoint untuk login pengguna
app.post("/login", (req, res) => {
  const { email, password } = req.body;

  // Validasi input
  if (!email || !password) {
    return res.status(400).json({ error: "Email dan password harus diisi" });
  }

  // Query untuk mencari user berdasarkan email dan password
  const query = `
    SELECT * FROM users WHERE email = ? AND password = ?
  `;
  const values = [email, password];

  db.query(query, values, (err, results) => {
    if (err) {
      console.error("Error saat login:", err);
      return res.status(500).json({ error: "Terjadi kesalahan saat login" });
    }

    // Jika user tidak ditemukan
    if (results.length === 0) {
      return res.status(401).json({ error: "Email atau password salah" });
    }

    // Kirim respons sukses
    const user = results[0];
    res.status(200).json({ message: "Login berhasil", user });
  });
});

// Jalankan server di port 3000
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
