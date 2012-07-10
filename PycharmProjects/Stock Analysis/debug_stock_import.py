# debug script for importing stock info from Yahoo Finance

import ImportStockInfo as stock
import StockRetriever as stockR
import sys

def main( ):
	""" sample
	"""
	data = stock.get_all('GOOG')
	print data['price']

	stocks = stockR.StockRetriever()
	info = stocks.get_current_info(["GOOG"])
	print info
	info = stocks.get_industry_ids()
	print info[0]
	info = stocks.get_industry_index('132')
	print info

if __name__ == "__main__":
	sys.exit( main( ) )
