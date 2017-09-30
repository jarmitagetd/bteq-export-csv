Program written to enable quick generation of bteq scritps to provide sample data sets to end users in csv format.  
BTEQ provides a header record so was chosen over TPT.  Installation notes and how to run:

-- install: just copy the folder bteq-Export-csv into your user folder on Linux (eg /home/james/)
-- check the path is correct in the file expbteq.sh.  You can check your BTEQ path by running the command "which bteq"
-- you can change the SQL statement if required in the file sql/bteqexp.sql
-- TO RUN ./expbteq.sh or bash expbteq.sh

If further information is required then james.armitage@teradata.com !!

v1.1 adds the ability to process where clause predicates.  See sql/bteqexp.sql

