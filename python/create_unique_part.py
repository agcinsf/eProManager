import pandas as pd
import fuzzy
import sys
import datetime as dt

#Proposed is deposited into the "default Temp directory"
Proposed = pd.read_table(sys.argv[1],error_bad_lines = False)

#this program needs a campus and supplier name.  They are taken from the command
Campus= sys.argv[2]
Supplier = sys.argv[3]

dmeta = fuzzy.DMetaphone()
today = dt.date.today()

def create_uniqueID(df):
    df['DMeta Manf']=df['Manufacturer Name'].astype('str').apply(lambda x: dmeta(x))
    df['DMeta Manf Str']=df['DMeta Manf'].apply(lambda x:x[0] if x[1] is None else x[0] + x[1])
    df['UOM Edited']=df['Packaging UOM'].str.replace('.*box.*','BX').str.replace('.*package.*','PK').str.replace('.*case.*','CS').str.replace('.*each.*','EA')
    df['UOM Edited'] = df['UOM Edited'].astype('str').str[-2:] 
    df['Manufacturer Part Number Edited']=df['Manufacturer Part Number'].str.replace("-", "").str.replace(",","").str.replace("/","").str.replace("_","").str.replace(".","").str.replace("'","")
    df['Unique ID'] = df.apply(lambda x: '%s,%s,%s' % (x['DMeta Manf Str'],x['Manufacturer Part Number Edited'],x['UOM Edited']),axis=1)
    df['Supplier']= Supplier
    df['Campus/UCOP']=Campus
    df['Date Uploaded']=today

create_uniqueID(Proposed)
Proposed=Proposed.drop({'DMeta Manf','DMeta Manf Str','Manufacturer Part Number Edited'}, axis=1)

Proposed.to_csv('./temp/proposed.csv',index=False,header=False)
