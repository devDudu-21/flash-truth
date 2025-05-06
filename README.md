# FlashTruth

## USB Flash Drive Real Capacity Verifier

FlashTruth is a command-line (CLI) tool for Linux, written in Shell Script, that verifies the authenticity of USB flash drives by testing their actual storage capacity and collecting critical device information.

It helps identify counterfeit devices, perform `f3` write/read tests, format drives, generate `.txt` reports, and operate in multiple languages (English/Portuguese).

---

## 🔍 Features

- View detailed USB drive information (model, vendor, serial, filesystem, etc.)
- Trust score system (0–10) for device authenticity
- Write/read test using the `f3` tool
- Detects content before testing and offers formatting
- Format option with filesystem selection (FAT32, exFAT, ext4)
- Automatic report generation in `.txt` format
- Multilingual support (EN/PT)
- Custom ASCII art interface

---

## 🖥️ Requirements

- `bash`
- `f3` (auto-installed)
- `lsblk`, `udevadm`, `lsusb`, `df`, `find`, `bc`
- Root privileges required for formatting

---

## 🚀 How to use

1. Clone this repository or copy the `flashtruth.sh` script.
1. Grant execution permissions:

```bash
chmod +x flashtruth.sh
```

1. Run the script:

```bash
./flashtruth.sh
```

1. Follow the interactive menu.

---

## 🌐 Language

The default language is **Portuguese**, but you can switch to **English** by changing the following variable at the top of the script:

```bash
LANG_FLASH=en  # or pt
```

---

## 📁 Reports

When checking a USB drive, FlashTruth will automatically generate a report in the format:

```plaintext
flashtruth_report_YYYY-MM-DD_HHMM.txt
```

---

## ⚠️ Warning

⚠️ The format function **will erase all data** on the flash drive. Use with caution.

---

---

## ❗❗ IMPORTANT WARNING – PLEASE READ ❗❗

### ⚠️ FlashTruth includes a disk **format (erase)** function

- **This feature will irreversibly delete** all data on the selected USB flash drive.
- Make sure you have selected the correct device **before proceeding**.
- **Always back up** important data before using this software.

### 🚫 I, the author, am **not responsible** for

- Data loss
- Hardware damage
- Unintended formatting
- Or any problems or consequences arising from the use of this tool

**USE AT YOUR OWN RISK. NO WARRANTY IS PROVIDED.**

---

## 📜 License

We are licensed under:

```plaintext
MIT License
(C) 2025 Eduardo Fernandes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

Made with honor, code, and darkness by **devDudu-21** 👑
