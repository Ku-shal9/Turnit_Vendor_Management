from flask import Flask, render_template, request, redirect, url_for
import pandas as pd
import plotly.express as px
import plotly
import json
from sqlalchemy import create_engine, text

app = Flask(__name__)

engine = create_engine("mysql+mysqlconnector://root:Zenon#999@localhost:3306/turnit")

@app.route('/')
def index():
    query = "SELECT VendorID, Name, AverageRating, TagsCount, TimelinessPercentage, TotalWorkingPeriod FROM ScoreCard"
    df = pd.read_sql(query, con=engine)

    vendor_status_df = pd.read_sql("SELECT StatusVendor FROM Vendor", con=engine)
    status_count = vendor_status_df['StatusVendor'].value_counts().reset_index()
    status_count.columns = ['Status', 'Count']

    charts = {
        'AverageRating': px.bar(df, x='VendorID', y='AverageRating', title='Average Rating by Vendor'),
        'TagsCount': px.bar(df, x='VendorID', y='TagsCount', title='Complaint Tags Count by Vendor'),
        'TimelinessPercentage': px.bar(df, x='VendorID', y='TimelinessPercentage', title='Timeliness % by Vendor'),
        'TotalWorkingPeriod': px.line(df, x='VendorID', y='TotalWorkingPeriod', title='Total Working Period (Months)'),
        'VendorStatusPie': px.pie(status_count, names='Status', values='Count', title='Vendor Status Distribution')
    }

    graphJSON = {name: json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder) for name, fig in charts.items()}
    top_vendors = df.sort_values(by='AverageRating', ascending=False).head(5).to_dict(orient='records')

    return render_template('dashboard.html', graphJSON=graphJSON, top_vendors=top_vendors)

@app.route('/add_vendor', methods=['GET', 'POST'])
def add_vendor():
    if request.method == 'POST':
        # Get form data
        name = request.form.get('name')
        email = request.form.get('email')
        hired_date = request.form.get('hired_date')
        status = request.form.get('status')
        address_id = request.form.get('address_id')

        # Basic validation
        if not all([name, email, hired_date, status, address_id]):
            return "All fields are required.", 400

        # Insert into DB
        with engine.connect() as conn:
            sql = text("""
                INSERT INTO Vendor (Name, Email, HiredDate, StatusVendor, AddressID)
                VALUES (:name, :email, :hired_date, :status, :address_id)
            """)
            conn.execute(sql, {
                'name': name,
                'email': email,
                'hired_date': hired_date,
                'status': status,
                'address_id': int(address_id)
            })
            conn.commit()

        return redirect(url_for('index'))

    # GET request shows the form
    return render_template('add_vendor.html')

if __name__ == '__main__':
    app.run(debug=True)
