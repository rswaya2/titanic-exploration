/* Using SAS to explore Titanic data from Kaggle*/

PROC IMPORT DBMS=csv OUT=titanic replace 
		DATAFILE="/folders/myfolders/train.csv";
	GETNAMES=YES;
RUN;

PROC FREQ data=titanic;
	TITLE 'Breaking Down Survival by Sex';
	TABLES sex*survived;
RUN;

PROC SGPANEL data=titanic;
	TITLE 'Age Histogram';
	PANELBY sex;
	HISTOGRAM age / GROUP=survived;
RUN;


/*Creating age ranges so that data is easier to read */

DATA titanic;
	LENGTH agerange $25;
	SET titanic;

	IF 0=<age<10 THEN
		agerange="ones";
	ELSE IF 10=<age<20 THEN
		agerange="teens";
	ELSE IF 20=<age<30 THEN
		agerange="twenties";
	ELSE IF 30=<age<40 THEN
		agerange="thirties";
	ELSE IF 40=<age<50 THEN
		agerange="forties";
	ELSE IF 50=<age<60 THEN
		agerange="fifties";
	ELSE IF 60=<age THEN
		agerange="sixty and above";
	ELSE
		agerange="missing";
RUN;

/*Creating exploratory plots*/

ods graphics on;

PROC FREQ DATA=titanic ORDER=freq;
	TABLES agerange survived agerange*survived/plots=freqplot(type=dotplot 
		scale=percent);
	TABLES sex sex*survived/plots=freqplot(type=dotplot scale=percent);
RUN;