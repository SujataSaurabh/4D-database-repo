import pandas as pd

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
 
 # Step 1: Find the first cycle for each PI
first_cycle = data.loc[data.groupby('pi_id')['cycle_id'].idxmin()].reset_index(drop=True)

# Step 2: Identify PI IDs where zero resources were allocated in their first cycle
zero_allocated_first_cycle = first_cycle[first_cycle['resource_allocated'] == 0]

# Step 3: Filter the original data for the PIs identified in Step 2
subsequent_cycles = data[data['pi_id'].isin(zero_allocated_first_cycle['pi_id'])]


# # Step 4: Check for subsequent cycles with zero allocation and collect all information
# print(subsequent_cycles)
results = []
i = 0 
for pi_id in zero_allocated_first_cycle['pi_id']:
    pi_data = subsequent_cycles[subsequent_cycles['pi_id'] == pi_id]
    pi_data_sorted = pi_data.sort_values('cycle_id')
    first_cycle_row = pi_data_sorted.iloc[0]  # First cycle data
    pi_data_after_first = pi_data_sorted.iloc[1:]  # Exclude the first cycle
    sum_of_resources = pi_data_after_first['resource_allocated'].sum()
    # print("sum ", pi_id, "   and   ", sum_of_resources)
    if sum_of_resources == 0: 
        i+=1
        results.append({
            "pi_id": pi_id, 
            "first_cycle_id": first_cycle_row['cycle_id'],
            "year": first_cycle_row['cycle_year']
            # "times_they_got_rejected": count_pis
            })
    # subsequent_cycles_with_allocation = pi_data_after_first[pi_data_after_first['resource_allocated'].sum() == 0]
    # print("pi ", pi_id)
    # print("subsequent_cycles_with_allocation - ", subsequent_cycles_with_allocation)
    # if subsequent_cycles_with_allocation== True:
    #     # count_pis = len(subsequent_cycles_with_allocation)
    #     results.append({
    #         "pi_id": pi_id, 
    #         "first_cycle_id": first_cycle_row['cycle_id']
    #         # "times_they_got_rejected": count_pis
    #         })
        # for _, row in subsequent_cycles_with_allocation.iterrows():
        #     # Append both first and subsequent cycle information
        #     results.append({
        #     "pi_id": pi_id, 
        #      "first_cycle_id": first_cycle_row['cycle_id'],
        #      "times_they_got_rejected": count_pis
        #     })
      

# Convert results to a DataFrame for better viewing
results_df = pd.DataFrame(results)
print("total pis: ", i)
# print(results_df.loc[10:50])
# Output the results
print("\nPIs with zero allocation in the first cycle and never got any beamtime ")
print(results_df)
results_df.to_csv('/Users/sujatagoswami/Documents/ALS_DATA/pis_never_got_beamtime.csv', index=False)

# print("Results saved to 'results.csv'")