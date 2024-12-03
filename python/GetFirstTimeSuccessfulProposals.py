import pandas as pd

# Load your data into a DataFrame
# Example: data = pd.read_csv('your_data.csv')
# Sample DataFrame structure
 

column_names = ['pi_id', 'cycle_id', 'proposal_type', 'resource_requested', 'resource_allocated', 'cycle_end_date', 'proposal_cycle']
data = pd.read_csv('/Users/sujatagoswami/Documents/ALS_DATA/proposal_beamlines_summary_2.csv', names=column_names)

# Ensure there is a 'category' column in the dataset
if 'proposal_type' in data.columns:
    # Filter out rows where category is "ap"
    data = data[data['proposal_type'] != 'AP']
else:
    raise ValueError("The dataset does not contain a 'category' column.")

print("size of data: ", data.size)
data['cycle_year'] =  pd.to_datetime(data['cycle_end_date'][1:],format="%m/%d/%y").dt.year
 
# Filter rows where resources were allocated
allocated = data[data['resource_allocated'] > 0]
print("0:\n", allocated)

# Find the first allocation date for each PI
first_allocation = allocated.groupby('pi_id')['cycle_year'].min().reset_index()
print("1: \n",first_allocation)
# Add the year of the first allocation
first_allocation['Year'] = first_allocation['cycle_year'] 

# Merge with the original allocated data to get full details
first_allocation_details = pd.merge(first_allocation, allocated, on=['pi_id', 'cycle_year'], how='left')
print("2: \n", first_allocation_details)

# Break down the list of PIs by year
pis_by_year = first_allocation_details.groupby('cycle_year')
 
# Prepare a list to store all grouped data for exporting
csv_data = []

# Output the breakdown for each year
for year, group in pis_by_year:
    group['Year'] = year
    csv_data.append(group)
    
    # print(year, group)

 
# data_to_save_df = pd.DataFrame(pis_by_year['pi_id'].count())
# output_file = "/Users/sujatagoswami/Documents/ALS_DATA/PIs_First_Allocation_CountPerYear.csv"
# data_to_save_df.to_csv(output_file, index=False)


# Combine all data into a single DataFrame
# final_csv_data = pd.concat(csv_data)
# # Save the data to a CSV file
# output_file = "/Users/sujatagoswami/Documents/ALS_DATA/PIs_First_Allocation_By_Year.csv"
# final_csv_data.to_csv(output_file, index=False)

# print(f"\nYear: {year}")
# print(group[['pi_id', 'cycle_id', 'resource_requested', 'resource_allocated', 'cycle_year']])



