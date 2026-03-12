# Assembly Storage Management Simulator

This project implements a simplified **storage management system** written in **x86 Assembly**, developed as part of the **Computer Systems Architecture course**.

The program simulates how an operating system manages file storage in memory blocks. Files are identified using descriptors and are stored in contiguous blocks within a simulated storage device.

The implementation focuses on the **core storage operations**, including adding files, retrieving file locations, deleting files, and memory defragmentation.

## Implemented Features

The project implements the requirements necessary to achieve a **grade up to 7**, including:

### One-Dimensional Storage Model
A simplified storage device represented as a linear array of memory blocks.

Supported operations:

- **ADD** – store files in the first available contiguous block interval
- **GET** – return the block interval where a file is stored
- **DELETE** – remove a file and free its allocated blocks
- **DEFRAGMENTATION** – reorganize memory so that files are stored compactly without gaps

### Two-Dimensional Storage Model
A matrix-based storage representation simulating a disk-like structure.

Supported operations:

- **ADD** – allocate files on contiguous blocks on the same row
- **GET** – return the coordinates of the stored file
- **DELETE** – remove files and update the storage matrix

## Storage Model

The simulated storage system follows these simplified rules:

- storage capacity is divided into **blocks**
- each block stores data from **a single file**
- files are stored **contiguously**
- files are identified by **descriptors (IDs between 1 and 255)**

## Technologies Used

- **x86 Assembly (AT&T syntax)**
- **Linux system calls**
- **C standard library functions** (`scanf`, `printf`)

## Academic Context

This project was developed for the **Computer Systems Architecture laboratory** and demonstrates low-level memory management concepts and storage allocation algorithms implemented directly in assembly language.
