import pandas as pd
# Load the results file
			
column_names = ['pi_id', 'first_cycle_id', 'first_proposal_cycle', 'first_cycle_end_date', 'first_cycle_requested', 'first_cycle_allocated', 'first_proposal_type', 'subsequent_cycle_id', 'subsequent_proposal_cycle', 'subsequent_cycle_end_date', 'subsequent_cycle_requested', 'subsequent_cycle_allocated', 'subsequent_proposal_type']
results_df = pd.read_csv('/Users/sujatagoswami/Documents/ALS_DATA/people_with_first_funding_subsequent_funding_updated_1.csv', names=column_names)

# Ensure there is a 'category' column in the dataset
if 'subsequent_proposal_type' in results_df.columns:
    # Filter out rows where category is "ap"
    results_df = results_df[results_df['subsequent_proposal_type'] != 'AP']
else:
    raise ValueError("The dataset does not contain a 'category' column.")

# Extract year from the 'first_cycle_date' and 'subsequent_cycle_date': 930:935
# print(pd.to_datetime(results_df['subsequent_cycle_end_date'][1:],format="%m/%d/%y"))
results_df['first_cycle_year'] =  pd.to_datetime(results_df['first_cycle_end_date'][1:],format="%m/%d/%y").dt.year
results_df['subsequent_cycle_year'] = pd.to_datetime(results_df['subsequent_cycle_end_date'][1:],format="%m/%d/%y").dt.year
 
# Count the number of proposals for each year in both columns
first_cycle_counts = results_df['first_cycle_year'].value_counts().sort_index()
subsequent_cycle_counts = results_df['subsequent_cycle_year'].value_counts().sort_index()

# Combine counts from both columns
total_proposals_per_year = first_cycle_counts.add(subsequent_cycle_counts, fill_value=0).astype(int)

# Convert the result to a DataFrame for easy viewing
proposals_per_year_df = total_proposals_per_year.reset_index()
proposals_per_year_df.columns = ['Year', 'Number of Proposals']

# Output the result
# print("\nNumber of Proposals Per Year:")
# print(proposals_per_year_df)

# # Save the result to a CSV file
# proposals_per_year_df.to_csv('/Users/sujatagoswami/Documents/ALS_DATA/proposals_per_year.csv', index=False)
# print("\nNumber of proposals per year saved to 'proposals_per_year.csv'")

# Counting number of PIs per year

# # Load the filtered dataset
# non_ap_proposals = pd.read_csv('non_ap_proposals.csv')

# Ensure the dataset has the necessary columns
if 'first_cycle_end_date' in results_df.columns and 'subsequent_cycle_end_date' in results_df.columns:
    # Extract year from 'first_cycle_date' and 'subsequent_cycle_date'
    # results_df['first_cycle_year'] = pd.to_datetime(results_df['first_cycle_end_date']).dt.year
    # results_df['subsequent_cycle_year'] = pd.to_datetime(results_df['subsequent_cycle_end_date']).dt.year
    
    # Count unique PIs per year for first and subsequent cycles
    first_cycle_pi_counts = results_df.groupby('first_cycle_year')['pi_id'].nunique()
    subsequent_cycle_pi_counts = results_df.groupby('subsequent_cycle_year')['pi_id'].nunique()
    
    print(first_cycle_pi_counts , subsequent_cycle_pi_counts)
    
    # Combine the counts from both first and subsequent cycles
    # total_pis_per_year = first_cycle_pi_counts.add(subsequent_cycle_pi_counts, fill_value=0).astype(int)
    total_pis_per_year = first_cycle_pi_counts

    # Convert to a DataFrame for easy viewing
    pis_per_year_df = total_pis_per_year.reset_index()
    pis_per_year_df.columns = ['Year', 'Number of PIs']


    # Save the result to a CSV file
    pis_per_year_df.to_csv('/Users/sujatagoswami/Documents/ALS_DATA/pis_per_year.csv', index=False)
    
    # Output the result
    print("\nNumber of PIs Per Year:")
    print(pis_per_year_df, pis_per_year_df['Number of PIs'].sum())
    print("\nNumber of PIs per year saved to 'pis_per_year.csv'")
else:
    raise ValueError("The dataset does not contain 'first_cycle_date' or 'subsequent_cycle_date' columns.")

