# Turnit Vendor Management

## Project Overview

This repository contains the Turnit Vendor Management project for DATA210. The project is designed to manage vendors, properties, jobs, payments, feedback, and complaints for a property management system. It includes a MySQL database schema, a Flask web application, and interactive dashboards for vendor performance analysis.

---

## Directory Structure

```
Turnit_Vendor_Management/
│
├── README.md                   # Project documentation and instructions
├── Turnit_overall_code.sql     # MySQL database schema and sample queries
├── app.py                      # Main Flask application
├── templates/                  # HTML templates for Flask (dashboard, forms)

```

---

## File Descriptions

- **README.md**: Project overview, setup instructions, and usage guidelines.
- **Turnit_overall_code.sql**: Contains SQL code for database creation, table definitions, views, and CRUD operations.
- **app.py**: Flask web application for managing vendors, displaying dashboards, and handling user input.
- **templates/**: HTML templates for rendering web pages (e.g., `dashboard.html`, `add_vendor.html`).

---

## Features

- **Vendor Management**: Add, view, and analyze vendor information.
- **Job Tracking**: Track jobs assigned to vendors and their completion status.
- **Payment Processing**: Manage payments for completed jobs.
- **Feedback & Complaints**: Collect feedback and complaints for vendor performance evaluation.
- **Interactive Dashboard**: Visualize vendor ratings, timeliness, complaints, and status distribution using Plotly charts.
- **Database Views**: Predefined views for vendor performance and job status.

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/Turnit_Vendor_Management.git
cd Turnit_Vendor_Management
```

### 2. Set Up the Database

- Install MySQL and create a database user.
- Run the SQL script to set up the schema and sample data:

```bash
mysql -u <username> -p < Turnit_overall_code.sql
```

### 3. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Database Connection

- Update the connection string in `app.py` if needed:
  ```python
  engine = create_engine("mysql+mysqlconnector://<username>:<password>@localhost:3306/turnit")
  ```

### 5. Run the Flask Application

```bash
python app.py
```

- Access the dashboard at [http://localhost:5000](http://localhost:5000).

---

## Usage

- **Dashboard**: View vendor performance metrics and top vendors.
- **Add Vendor**: Use the `/add_vendor` route to add new vendors via a web form.
- **Database Operations**: Use the provided SQL queries for CRUD operations and analysis.

---

## Contribution

Feel free to contribute by submitting pull requests or opening issues for bugs and feature requests.  
Please follow standard coding and documentation practices.

---

## License

This project is for educational purposes as part of DATA210.  
For other uses, please contact the repository owner.

---

## Contact

For questions or support, please open an issue or contact the
