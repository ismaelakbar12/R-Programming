Dasar Pemrograman R - Variable, Vector dan Operator
================
Penulis : Ismail Akbar \| Prof. Dr. Suhartono M.Kom \| Magister
Informatika \| UIN Maulana Malik Ibrahim Malang \|
3 Februari 2021

### Pengertian

Dalam bidang *Data Sience* memiliki 2 paltform bahasa pemrograman yang
sangat populer yaitu Python dan R. Bahasa pemrograman R sangat baik
untuk uji statistik, klasifikasi, klasterisasi dan baik dalam
visualisasi data, dan fungsi lainnya.

Bahasa Pemrograman R adalah perangkat lunak (*Software*) untuk analisis
statistika dan grafik yang awalnya dibuat oleh **Ross Ihaka** dan
**Robert Gentlemen** di University of Auckland New Zealand dan akhirnya
dilanjutkan oleh **R Development Core Team**.

Berbeda dengan bahasa pemrograman lainnya, bahasa R berupa *interpreter*
yang dituliskan baris per baris seperti di )Command Line Interface).
Bahasa R tidak sesulit bahasa pemrograman lainnya, yang dimana bahasa R
merupakan turunan dari bahasa pemrograman S, sedangkan bahasa S turunan
dari bahasa pemrograman C. Maka bisa disimpulkan bahasa R akan terlihat
mirip dengan bahasa pemrograman C.

Pada Artikel ini akan membahas beberapa dasar bahasa pemrograman R :

#### A. Variabel

Seperti bahasa pemrograman lainnya, bahasa R memiliki sebuah variabel
yang merupakan suatu hal yang penting dalam bahasa pemrograman. Aturan
penulisan variabel pada bahasa pemrograman R sama dengan bahasa
pemrograman lainnya, yaitu :

1.  Variabel berupa kombinasi huruf (Kapital dan juga huruf kecil),
    angka, titik dan garis bawah (*underscore*).
2.  Harus diawali dengan huruf atau titik, jika berawal dengan titik,
    selanjutnya tidak bisa menggunakan angka. Lebih disarankan penamaan
    variabel sebaiknya dimulai dengan huruf.
3.  Tidak diperbolehkan menggunakan spasi, tanda spasi bisa diganti
    dengan tanda \_ (*Underscore*) atau titik.
4.  Hindari menggunakan kata-kata yang sama dengan perintah-perintah
    yang dikenali oleh bahasa R, seperti : **IF, ELSE, REPEAT, WHILE,
    FUNCTION, TRUE, FALSE**, dan sebagainya.
5.  Huruf besar dan kecil berbeda pada bahasa pemrograman R (*case
    sensitive*).

Deklarasi variabel pada bahasa R cukup dengan memasukkan nilai kedalam
variabelnya menggunakan operator = atau &lt;-, operator &lt;- lebih umum
digunakan karena merupakan operator asli dari bahasa R. Contoh :

-   Variabel Numerik (Angka) Menggunakan operator =

``` r
a = 5
b = 3
c = a+b
print(c)
```

    ## [1] 8

Menggunakan operator &lt;-

``` r
a <- 5
b <- 6
print((a+b)/2)
```

    ## [1] 5.5

-   Variabel String (Text) Menggunakan operator =

``` r
a = "Hello World"
b = "'Hello World dengan petik 1'"
c = '"Hello World dengan petik 2"'
print(b)
```

    ## [1] "'Hello World dengan petik 1'"

Menggunakan operator &lt;-

``` r
s <- "Hello World"
s1 <- "'Hello World dengan petik 1'"
s2 <- '"Hello World dengan petik 2"'
print(s)
```

    ## [1] "Hello World"

-   Variabel Date (Tanggal)

``` r
hari_ini <- Sys.Date()
print(hari_ini)
```

    ## [1] "2021-03-02"

#### B. Vector

Vector pada bahasa pemrograman R merupakan data array yang dapat
menyimpan banyak data dalam 1 variabel saja dan diakses menggunakan
indeks. Pada bahasa R indeks dimulai dari angka 1 bukan 0. Insialisasi
vector pada bahasa R menggunakan fungsi bernama C(), C merupakan
singkatan dari **Combine** Berikut contohnya :

``` r
x <- c(1, 2, 3, 4, 5)
y <- c(6, 7, 7.5, TRUE, "hello")
print(y[3])
```

    ## [1] "7.5"

Pada bahasa pemrograman R, vector juga bisa dilakukan sebuah operasi
perhitungan, akan tetapi jumlah karakter yang akan dihitung harus
seragam atau berjumlah sama. Sebagai berikut :

``` r
x <- c(1, 2, 3, 4, 5)
y <- c(1, 1, 1, 1, 1)
print(x + y) 
```

    ## [1] 2 3 4 5 6

Untuk menciptakan vektor dengan panjang tertenu dan perbedaan yang
ditentukan antar elemen. Digunakan fungsi **sequance()** pada bahasa
pemrograman R.

``` r
sequence(4) 
```

    ## [1] 1 2 3 4

``` r
sequence(6) 
```

    ## [1] 1 2 3 4 5 6

Menggabungkan antar sequance vector

``` r
sequence(c(4, 6)) 
```

    ##  [1] 1 2 3 4 1 2 3 4 5 6

Penulisan sequance juga bisa dilakukan seperti ini

``` r
seq(3, 9)
```

    ## [1] 3 4 5 6 7 8 9

atau bisa dilakukan secara sederhana

``` r
2:6
```

    ## [1] 2 3 4 5 6

#### C. Operator

Pada bahasa R terdapat sejumlah operator operasi yang penting, seperti
bahasa pemrograman lainnya, antara lain:

**1. Operator Aritmatika**

Proses perhitungan akan ditangani oleh fungsi khusus. Bahasa R akan
memahami urutannya secara benar. *Kecuali* kita secara eksplisit
menetapkan yang lain. Sebagai contoh tuliskan dan jalankan sintaks
berikut :

``` r
3+2*5
```

    ## [1] 13

sintaks diatas akan berbeda hasil jika seperti sintaks dibawah ini ;

``` r
(3+2)*5
```

    ## [1] 25

Dari hasil dua sintaks diatas maka dapat disimpulkan bahwa pada bahasa R
ketika kita tidak menetapkan urutan perhitungan menggunakan tanda
kurung, secara otomatis akan menghitung terlebih dahulu perkalian atau
pembangian.

Operator Aritmatika yang disediakan bahasa R :

| **Simbol** | **Nama Simbol**   | **Keterangan**                                                             |
|------------|-------------------|----------------------------------------------------------------------------|
| `+`        | *Addition*        | Untuk operasi penjumlahan                                                  |
| `-`        | *Substraction*    | Untuk operasi pengurangan                                                  |
| `*`        | *Multiplication*  | Untuk operasi perkalian                                                    |
| `/`        | *Division*        | Untuk operasi pembagian                                                    |
| `^`        | *Eksponentiation* | Untuk operasi pemangkatan                                                  |
| `%%`       | *Modulus*         | Untuk mencari sisa pembagian                                               |
| `%/%`      | *Integer*         | Untuk mencari bilangan bulat hasil pembagian saja dan tanpa sisa pembagian |

**2. Operator perbandingan**

Operator perbandingan digunakan untuk membandingkan satu objek dengan
objek lainnya pada bahasa pemrograman R.

| **Simbol** | **Keterangan**            | **Deskripsi**                                                                               |
|------------|---------------------------|---------------------------------------------------------------------------------------------|
| `==`       | *Sama dengan*             | Bernilai **TRUE** jika kedua objek bernilai sama                                            |
| `!=`       | *Tidak sama dengan*       | Bernilai **TRUE** jika kedua objek tidak bernilai sama                                      |
| `>`        | *Lebih besar dari*        | Bernilai **TRUE** jika nilai objek kanan lebih besar dari nilai objek kiri                  |
| `<`        | *Lebih kecil dari*        | Bernilai **TRUE** jika nilai objek kanan lebih kecil dari nilai objek kiri                  |
| `>=`       | *Lebih besar sama dengan* | Bernilai **TRUE** jika nilai objek kanan lebih besar atau sama dengan dari nilai objek kiri |
| `<=`       | *Lebih kecil sama dengan* | Bernilai **TRUE** jika nilai objek kanan lebih kecil atau sama dengan dari nilai objek kiri |

Contoh penerapan operator perbandingan :

``` r
x <- 30
y <- 45

print(x > y)
```

    ## [1] FALSE

``` r
print(x < y)
```

    ## [1] TRUE

``` r
print(x == y)
```

    ## [1] FALSE

``` r
print(x != y)
```

    ## [1] TRUE

``` r
print(y <= x)
```

    ## [1] FALSE

``` r
print(y >= x)
```

    ## [1] TRUE

**3. Operator logika**

Operator logika hanya berlaku pada vektor dengan tipe logical, numeric,
atau complex. Semua angka bernilai 1 akan dianggap bernilai logika
**TRUE**.

| **Simbol** | **Keterangan**                     |
|------------|------------------------------------|
| `&&`       | Operator logika *AND*              |
| `||`       | Operator logika *OR*               |
| `!`        | Operator logika *NOT*              |
| `|`        | Operator logika *OR element wise*  |
| `&`        | Operator logika *AND element wise* |

Contoh penerapan operator logika :

``` r
x <- c(FALSE,FALSE,TRUE)
y <- c(TRUE,FALSE,TRUE)

print(x&&y)
```

    ## [1] FALSE

``` r
print(x||y)
```

    ## [1] TRUE

``` r
print(!y)
```

    ## [1] FALSE  TRUE FALSE

``` r
print(x|y)
```

    ## [1]  TRUE FALSE  TRUE

``` r
print(x&y)
```

    ## [1] FALSE FALSE  TRUE
