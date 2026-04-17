# SETUP GUIDE - Flutter Login App with Database

## 📋 Step-by-Step Setup

### STEP 1: Update Database (phpMyAdmin)

1. Buka **phpMyAdmin** di browser: `http://localhost/phpmyadmin`
2. Buka **SQL tab** dan copy seluruh kode dari file:
   ```
   database/flutter_login_db.sql
   ```
3. Paste di SQL editor phpMyAdmin dan klik **Execute**
4. Database dan table `users` dengan kolom baru: `phone`, `address` sudah siap! ✅

---

### STEP 2: Copy Backend PHP Files

Backend PHP files sudah dibuat di folder `lib/` untuk referensi Anda:
- `lib/backend_register.php` → Copy ke `htdocs/backend/register.php`
- `lib/backend_profile.php` → Copy ke `htdocs/backend/profile.php`

**Langkah:**
1. Buka folder: `C:\xampp\htdocs\backend\` (atau lokasi XAMPP Anda)
2. Copy file yang sudah ada: `db.php`, `login.php`
3. **Download/buat 2 file baru:**
   - **register.php** - Handle register dengan phone & address
   - **profile.php** - Handle GET & UPDATE profil

**Atau** gunakan file yang sudah ada di `lib/backend_register.php` dan `lib/backend_profile.php` sebagai referensi.

---

### STEP 3: Verifikasi Backend

1. Buka browser dan akses:
   ```
   http://localhost/backend/login.php
   ```
   Harusnya response: `{"success":false,"message":"Hanya POST"}`

2. Buka juga:
   ```
   http://localhost/backend/register.php
   http://localhost/backend/profile.php
   ```
   Harusnya sama response-nya (Hanya POST/GET)

---

### STEP 4: Update Flutter Code

✅ Sudah dilakukan otomatis! Perubahan:

**Register Page (lib/register.dart):**
- ✅ Ditambah input: No. Telepon, Alamat
- ✅ Mengirim data phone & address ke backend

**Profile Page (lib/profile.dart):**
- ✅ Fetch data profil dari database via `http://localhost/backend/profile.php`
- ✅ Mode view: Menampilkan 4 data (nama, email, no telp, alamat)
- ✅ Mode edit: Bisa ubah nama, no telp, alamat (email tidak bisa diubah)
- ✅ Button: Edit profil, Simpan, Batal, Logout
- ✅ Avatar dengan initial nama

**Main Page (lib/main.dart):**
- ✅ Bottom Navigation: Beranda + Profil
- ✅ Pass email dari login ke profil page

---

### STEP 5: Test Aplikasi

#### Flow 1: Register User Baru
1. Buka Flutter app
2. Klik "Belum punya akun? Daftar"
3. Isi form:
   - Nama: John Doe
   - Email: john@example.com
   - Password: secret123
   - No Telp: 0812-3456-7890
   - Alamat: Jl. Contoh No. 123
4. Klik "Register"
5. Harusnya berhasil dan redirect ke login ✅

#### Flow 2: Login
1. Isi Email: john@example.com
2. Isi Password: secret123
3. Klik "Login"
4. Harusnya berhasil dan masuk ke halaman Beranda ✅

#### Flow 3: Lihat & Edit Profil
1. Dari halaman Beranda, klik tab **"Profil"** di bottom navigation
2. Harusnya muncul data profil dari database:
   - Avatar dengan initial "J"
   - Nama: John Doe
   - Email: john@example.com
   - No Telp: 0812-3456-7890
   - Alamat: Jl. Contoh No. 123
3. Klik button **"Edit Profil"**
4. Ubah data (misalnya no telp jadi 0812-9999-9999)
5. Klik **"Simpan"**
6. Harusnya berhasil diupdate dan data tab berubah ✅

#### Flow 4: Logout
- Klik button **"Logout"** di halaman profil
- Harusnya redirect ke login page ✅

---

## 📂 File Structure Database

```
users table:
├── id (INT, PRIMARY KEY, AUTO_INCREMENT)
├── name (VARCHAR 100)
├── email (VARCHAR 150, UNIQUE)
├── password (VARCHAR 255)
├── phone (VARCHAR 20) ← BARU
├── address (TEXT) ← BARU
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP) ← BARU
```

---

## 🔗 API Endpoints

### 1. Register
```
POST /backend/register.php
Body: {
  "name": "John Doe",
  "email": "john@example.com",
  "password": "secret123",
  "phone": "0812-3456-7890",
  "address": "Jl. Contoh No. 123"
}
Response: {"success": true, "message": "Pendaftaran berhasil"}
```

### 2. Login (sudah ada)
```
POST /backend/login.php
Body: {
  "email": "john@example.com",
  "password": "secret123"
}
Response: {"success": true, "user": {...}}
```

### 3. Get Profil
```
GET /backend/profile.php?email=john@example.com
Response: {"success": true, "user": {
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "0812-3456-7890",
  "address": "Jl. Contoh No. 123"
}}
```

### 4. Update Profil
```
POST /backend/profile.php
Body: {
  "email": "john@example.com",
  "name": "John Doe Updated",
  "phone": "0812-9999-9999",
  "address": "Jl. Baru No. 456"
}
Response: {"success": true, "message": "Profil berhasil diupdate"}
```

---

## ⚠️ Troubleshooting

### Error: "Berhasil POST" tapi tidak tersimpan di database
- Cek apakah file `db.php` di `htdocs/backend/` sudah benar
- Cek database connection: username, password, database name

### Error: Tidak bisa load profil
- Pastikan email yang login sama dengan email di database
- Cek di browser: `http://localhost/backend/profile.php?email=john@example.com`
- Harusnya response dengan data user

### Error: Flutter crash saat klik "Edit Profil"
- Pastikan sudah hot reload atau hot restart
- Cek console untuk error message lengkap

---

## ✨ Features

✅ **Register**: Dengan 5 field (nama, email, password, no telp, alamat)
✅ **Login**: Email & password
✅ **Profile View**: Tampilkan 4 data dari database
✅ **Profile Edit**: Edit nama, no telp, alamat (email read-only)
✅ **Bottom Navigation**: Beranda + Profil
✅ **Logout**: Dari halaman profil atau beranda
✅ **Database**: Terintegrasi dengan MySQL
✅ **Password Hash**: Password di-hash dengan bcrypt di backend

---

Selesai! Aplikasi sudah siap digunakan! 🚀
