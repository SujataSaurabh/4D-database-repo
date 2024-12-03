import pandas as pd
#  source /Users/sujatagoswami/Documents/code/venv/bin/activate
# Load the dataset from a CSV file
# Replace 'data.csv' with the path to your file
# Define the column headers for the dataset
column_names = ['pi_id', 'cycle_id', 'proposal_type', 'resource_requested', 'resource_allocated', 'cycle_end_date', 'proposal_cycle']

data = pd.read_csv('/Users/sujatagoswami/Documents/ALS_DATA/proposal_beamlines_summary_2.csv', names=column_names)

 # Step 1: Find the first cycle for each PI
first_cycle = data.loc[data.groupby('pi_id')['cycle_id'].idxmin()].reset_index(drop=True)

# Step 2: Identify PI IDs where zero resources were allocated in their first cycle
zero_allocated_first_cycle = first_cycle[first_cycle['resource_allocated'] == 0]

# Step 3: Filter the original data for the PIs identified in Step 2
subsequent_cycles = data[data['pi_id'].isin(zero_allocated_first_cycle['pi_id'])]

# Step 4: Check for subsequent cycles with non-zero allocation
# Filter out the first cycle for each PI and check for non-zero allocation

# Step 4: Check for subsequent cycles with non-zero allocation and collect all information
# # Step 4: Check for subsequent cycles with non-zero allocation and collect all information
results = []
for pi_id in zero_allocated_first_cycle['pi_id']:
    pi_data = subsequent_cycles[subsequent_cycles['pi_id'] == pi_id]
    pi_data_sorted = pi_data.sort_values('cycle_id')
    first_cycle_row = pi_data_sorted.iloc[0]  # First cycle data
    pi_data_after_first = pi_data_sorted.iloc[1:]  # Exclude the first cycle
    subsequent_cycles_with_allocation = pi_data_after_first[pi_data_after_first['resource_allocated'] >= 0]
    if not subsequent_cycles_with_allocation.empty:
        for _, row in subsequent_cycles_with_allocation.iterrows():
            # Append both first and subsequent cycle information
            results.append({
                "pi_id": pi_id,
                "first_cycle_id": first_cycle_row['cycle_id'],
                "first_proposal_cycle": first_cycle_row['proposal_cycle'],
                "first_cycle_end_date": first_cycle_row['cycle_end_date'],
                "first_cycle_requested": first_cycle_row['resource_requested'],
                "first_cycle_allocated": first_cycle_row['resource_allocated'],
                "first_proposal_type": first_cycle_row['proposal_type'],
                "subsequent_cycle_id": row['cycle_id'],
                "subsequent_proposal_cycle": row['proposal_cycle'],
                "subsequent_cycle_end_date": row['cycle_end_date'],
                "subsequent_cycle_requested": row['resource_requested'],
                "subsequent_cycle_allocated": row['resource_allocated'],
                "subsequent_proposal_type":  row['proposal_type']
            })

# Convert results to a DataFrame for better viewing
results_df = pd.DataFrame(results)

# Output the results
print("\nPIs with zero allocation in the first cycle but some allocation in subsequent cycles:")
#print(results_df)
results_df.to_csv('/Users/sujatagoswami/Documents/ALS_DATA/people_with_first_funding_subsequent_funding_updated_1.csv', index=False)

print("Results saved to 'results.csv'")