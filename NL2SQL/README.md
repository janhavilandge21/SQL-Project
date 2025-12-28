
# 🧠 Natural Language to SQL (NL2SQL) using LangChain & Groq

An end-to-end **Natural Language → SQL (NL2SQL)** system that allows users to query a relational database using plain English.
Built using **LangChain**, **Groq LLM (LLaMA-3.1)**, and **SQLite**, and designed to run seamlessly on **Google Colab**.

---

## 🚀 Project Overview

Traditional database querying requires knowledge of SQL syntax and schema. This project removes that barrier by enabling users to interact with databases conversationally.

The system:

* Understands natural language questions
* Converts them into valid SQL queries
* Executes queries on a database
* Returns accurate, user-friendly answers
* Maintains conversational context for follow-up questions

---

## ✨ Key Features

* 🔍 **Natural Language → SQL Translation**
* 🧠 **Schema-Aware Query Generation**
* 🔁 **Few-Shot Learning for Higher Accuracy**
* 📊 **Dynamic Table Selection**
* 💬 **Conversational Memory for Follow-Up Queries**
* ⚡ **Groq-powered LLaMA-3.1 (Fast & Free)**
* ☁️ **Google Colab Compatible**

---

## 🛠️ Tech Stack

* **Python**
* **LangChain**
* **Groq API (LLaMA-3.1-70B)**
* **SQLite**
* **SQLAlchemy**
* **Pandas**
* **Google Colab**

---

## 📁 Project Structure

```
nl2sql-langchain-groq/
│
├── company.db
├── database_table_descriptions.csv
├── nl2sql_colab.ipynb
├── README.md
```

---

## 🧩 Database Schema

### `customers`

| Column         | Description   |
| -------------- | ------------- |
| customerNumber | Primary Key   |
| customerName   | Customer Name |
| country        | Country       |
| creditLimit    | Credit Limit  |

### `orders`

| Column         | Description |
| -------------- | ----------- |
| orderNumber    | Primary Key |
| customerNumber | Foreign Key |

---

## ⚙️ Setup Instructions (Google Colab)

### 1️⃣ Install Dependencies

```bash
pip install langchain langchain-community langchain-groq pandas sqlalchemy
```

### 2️⃣ Set Groq API Key

```python
import os
os.environ["GROQ_API_KEY"] = "your_groq_api_key_here"
```

### 3️⃣ Run the Notebook

Open and run:

```
nl2sql_colab.ipynb
```

---

## 💬 Example Queries

```
How many customers are there?
```

```
List customers and the number of orders they placed
```

```
Which customers are from France?
```

```
How many orders did they place?
```

```
Which customer has the highest credit limit?
```

---

## 🧠 Conversational Memory Example

**User:**

> Show customers from France

**User:**

> How many orders did they place?

✔️ The system understands **“they”** refers to **customers from France**
✔️ Generates the correct SQL automatically

---

## 🧪 Sample Output

```
Atelier graphique has placed 2 orders.
La Rochelle Gifts has placed 0 orders.
```

---

## 🎯 How This Project Helps

* Enables non-technical users to query databases
* Reduces dependency on SQL knowledge
* Improves productivity for analysts and business teams
* Demonstrates real-world use of LLMs in data systems

---

## 🧠 What I Learned

* Building NL2SQL pipelines with LangChain
* Prompt engineering for SQL generation
* Using Groq’s LLaMA-3.1 models
* Handling schema context and memory
* Designing conversational AI systems

---

## 📌 Future Enhancements

* Streamlit Web UI
* LangGraph-based agent flow
* SQL error recovery loop
* Support for MySQL / PostgreSQL
* Dynamic few-shot example selection

---

## 📄 License

This project is for **educational and learning purposes**.

---

## 🙌 Acknowledgements

* [LangChain](https://www.langchain.com/)
* [Groq](https://groq.com/)
* Google Colab

---


