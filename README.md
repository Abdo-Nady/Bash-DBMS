# Bash-DBMS
---
## Overview

Simple **Database Management System (DBMS)** using **Bash scripting** and **CSV files** to simulate tables.
Made for practicing Bash, file handling, and DBMS basics.

---

## Features

* Manage databases (create, list, connect, drop).
* Manage tables (create, list, drop).
* Insert & view data.
* Primary key support (no duplicates).
* Menu-driven interface.

---

## How It Works

* **Database = directory**
* **Table = CSV file**
* **Header row = column names**
* **Hidden .table.pk file = primary key info**

---

## Example

```bash
./main.bash
```

Insert row:

```
Enter row values (comma separated, 3 columns): 1,John,25
```

View table:

```
id   name   age
1    John   25
```

---

## Requirements

* Linux / macOS
* Bash + core utils (`awk`, `cut`, `grep`, `tail`, `head`, `column`)

---

## Author

Built by **Nady** for educational purposes.
