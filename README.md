# 🎯 8086 Assembly Programming Final Project

> **Course:** Microprocessor 8086  
> **Language:** Assembly x86 (8086)  
> **Environment:** DOS  

## 🚀 Project Overview

Welcome to my collection of 8086 assembly programs! This repository contains the final project for my Microprocessor 8086 course, showcasing various fundamental programming concepts implemented in low-level assembly language.

## 📁 Programs Collection

### 🔢 **GetInput_SumEvens.asm** - Smart Number Processor
- **What it does:** Gets 10 numbers from user (0-255 range)
- **Cool features:** 
  - Input validation (rejects invalid numbers)
  - Stores valid numbers in array
  - Uses bit masking to identify even numbers
  - Calculates sum of even numbers only
- **Techniques:** String-to-number conversion, array manipulation, bit operations

### 🔤 **Char_Process.asm** - Character Transformer
- **What it does:** Processes up to 20 characters with multiple transformations
- **Magic features:**
  - Flips case: `Hello` → `hELLO`
  - Sums all digits: `abc123xyz` → sum = 6
  - Counts special characters (ignores spaces)
  - Real-time character analysis
- **Techniques:** ASCII manipulation, character classification, multi-pass processing

### ⚠️ **ex3.asm** - Division by Zero Handler
- **What it does:** Creates a custom interrupt handler for division by zero
- **Epic features:**
  - Hijacks the interrupt vector table
  - Replaces default system behavior
  - Shows custom error message: "You can't divide by zero!!!"
  - Safely restores original handler
- **Techniques:** Interrupt vector manipulation, system-level programming, error handling

### 🔄 **Reverse_String.asm & Reverse_String.asm** - String Reversal Masters
- **What it does:** Reverses any input string using palindrome logic
- **Clever approach:**
  - Two-pointer technique (start ↔ end)
  - In-place swapping (memory efficient)
  - Works like palindrome checking but swaps characters
  - Example: `"hello"` → `"olleh"`
- **Techniques:** Pointer manipulation, in-place algorithms, string processing

### 🎯 **Additional Utilities**
- **Char_Process.asm:** Character processing utilities
- **GetInput_SumEvens.asm:** Input handling and even number operations

## 🛠️ Technical Highlights

### **Assembly Mastery Demonstrated:**
- 🔧 **Low-level I/O:** Direct DOS interrupt calls
- 🧠 **Memory Management:** Buffer handling, stack operations
- 🎮 **System Programming:** Interrupt vector manipulation
- 🔍 **Algorithm Implementation:** Two-pointer technique, bit masking
- 📊 **Data Structures:** Arrays, string buffers
- 🛡️ **Error Handling:** Input validation, interrupt safety

## 🚀 How to Run

### **Requirements:**
- 8086 Assembler (TASM, MASM, or NASM)
- DOS environment or DOSBox emulator
- Text editor or IDE

## 🎨 Program Features

| Program | Input Type | Processing | Output |
|---------|------------|------------|---------|
| ex1 | 10 numbers (0-255) | Even number detection & sum | Sum of even numbers |
| ex2 | 20 characters | Case flip + digit sum + counting | Transformed string + statistics |
| ex3 | Any division | Interrupt handling | Custom error message |
| ex4 | Text string | Two-pointer reversal | Reversed string |



## 🏆 Why This Matters

Assembly programming teaches you to think like the processor itself. Every instruction matters, every byte counts, and every register has a purpose. This project bridges the gap between high-level programming concepts and bare-metal hardware understanding.

---

> *"In assembly, you don't just write code - you sculpt instructions that speak directly to the soul of the machine."* 🤖

**Built with ❤️ and lots of debugging sessions** 🐛➡️✨
