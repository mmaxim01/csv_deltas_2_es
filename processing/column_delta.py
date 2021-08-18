import argparse
import sys
import pandas as pd 

def main(arg):
  parser = argparse.ArgumentParser()
  parser.add_argument("csv", help="Input CSV")
  parser.add_argument("column", help="Column name to calculate deltas")
  args = parser.parse_args()

  print ('Processing ' + args.csv)
  csv_df = pd.read_csv (args.csv)
  csv_df.to_csv(args.csv + '_backup')

  csv_df[args.column] = csv_df[args.column] - csv_df[args.column].shift()
  

  csv_df.to_csv(args.csv)
    
if __name__ == "__main__":
   main(sys.argv)

