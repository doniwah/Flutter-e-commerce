const express = require("express");
const cors = require("cors");
const app = express();

// Middleware untuk parsing JSON
app.use(express.json());

// Izinkan request dari domain lain
app.use(cors());

// Endpoint untuk registrasi pengguna
app.post("/register", (req, res) => {
  const { firstName, lastName, username, email, phone, password } = req.body;

  // Validasi input
  if (!firstName || !lastName || !username || !email || !phone || !password) {
    return res.status(400).json({ error: "All fields are required" });
  }

  // Simpan data pengguna (contoh sederhana, tanpa database)
  const user = { firstName, lastName, username, email, phone, password };
  console.log("User registered:", user);

  // Kirim respons sukses
  res.status(201).json({ message: "User registered successfully", user });
});

// Endpoint untuk login pengguna
app.post("/login", (req, res) => {
  const { email, password } = req.body;

  // Validasi input
  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  // Contoh validasi login (tanpa database)
  if (email === "whyddoni@gmail.com" && password === "password123") {
    return res.status(200).json({ message: "Login successful", user: { email } });
  } else {
    return res.status(401).json({ error: "Invalid email or password" });
  }
});

// Jalankan server di port 3000
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
