# Use the official IBM DB2 image as a base
FROM ibmcom/db2:11.5.8.0

# Create directories
RUN mkdir -p /var/custom /custom/csv

# Copy CSVs and script
COPY csv/ /custom/csv/
COPY scripts/load_csv_to_db2.sh /var/custom/load_csv_to_db2.sh

# Make the script executable
RUN chmod a+x /var/custom/load_csv_to_db2.sh

