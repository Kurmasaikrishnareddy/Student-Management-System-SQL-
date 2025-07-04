#1) Display all undergraduate student whose name starts with ‘S’ and is of length between 5 and 20.
select sname from student 
where sname like "S%" and length(sname)>=5;

#2) Display the student who are senior citizen (>=60).
select sname from student 
where timestampdiff(year,sdob,curdate())>=60;

#3) Display student who were born after 1st of June 1980. 
select sname,sdob from student 
where sdob>"1980-06-01";

#4)The student are suppose to only provide mobile numbers .All mobile numbers should start with  zero followed by 10 digits. 
#Display student name having invalid phone numbers. 
select sname,sphone from student 
where sphone not like "0%" or length(sphone)!=11 or sphone is null;

#5)All emails should have “@” anywhere after the first character and should end with “.com”.  
#Display count of students having invalid email id. 
select sname,semail from student 
where semail not like ".com%" and semail not like "%@%" or semail is null;

#6)Display the name and email of student who have a Gmail account. 
select sname,semail from student 
where semail like "%gmail%";

#7)Display the above record but do not consider invalid email id. 
select sname,semail from student 
where semail like ".com%" or semail  like "%@%" 

#8)Display the qualification and the total number of students registered based on their  qualifications. 
#(Alias use “totalStud” for total number of students) 
select squal,count(*) as totalStud from student
group by squal;

#9) Display the full name of the month and the total number of students who are having their  birthday in that month. 
#(Alias use “Month” and “Total”) 
select monthname(sdob) as Month,count(*) as Total from student
group by Month;

#10)Display the student name that was born in a leap year ordering by student name and year of  birth. 
select sname,year(sdob) from student
where year(sdob)%4=0 and year(sdob)%400!=0 and year(sdob)%100!=0;

#11) Display student whose city is Kolkata as “HomeStudent ” and others as “DistanceStudent”  under a column “Remarks”. 
#Also display the name and city of the student. 
select sname,scity,
case when scity = "Kolkata" then "Homestudent"
	else "Distancestudent"
    end as Remarks from student;

#12)Display count of students having no contact information. (Either email or phone). 
select count(*) from student
where semail is null or sphone is null;

#13) Display coursename having above average fees. 
select coursename from course 
where (select avg(coursefees) from course)<coursefees;

#14) Display coursename where fees are less than the average fees of its category. 
select coursename from course 
where (select avg(coursefees) from course)>coursefees;

#15) Display student name having duplicate email ids. 
select sname from student
where semail not like "%@%" and semail not like ".com%" or semail is null ;

#16) Display batchid, coursename, batch start date, batch end date for all batches. 
#(batch end  date=batch start date +course duration). 
select b.batchid,c.coursename,date(b.bsdate) as batch_start_date,date(b.bsdate+interval c.courseduration day) as batch_end_date from batch b
join course c on c.courseid=b.courseid
group by b.batchid,c.coursename;
select b.batchid,c.coursename,b.bsdate as batch_start_date,b.bsdate+interval c.courseduration hour as batch_end_date from batch b
join course c on c.courseid=b.courseid
group by b.batchid,c.coursename;

#17)Display all batchid having a difference of 10 hours and less between its starting and ending date
select b.batchid from batch b
join course c on c.courseid=b.courseid
where courseduration<10;

#18)Display student who enrolled for the batch after its start date.
select sname,e.edate,date(b.bsdate) from student s
join enrollment e on e.sid=s.sid
join batch b on b.batchid=e.batchid
where e.edate>date(b.bsdate);

#19) Display the studentid, studentname , totalfees for all student. 
select s.sid,s.sname,sum(c.coursefees) as totalfees from course c
join batch b on b.courseid=c.courseid
join enrollment e on e.batchid=b.batchid
join student s on s.sid=e.sid
group by s.sid,s.sname;

#20) Display the coursename having the highest enrollment. 
select coursename,count(*) as total from course c 
join batch b on b.courseid=c.courseid
join enrollment e on e.batchid=b.batchid
join student s on s.sid=e.sid
group by coursename
order by total desc
limit 1;

#21) Display student name having similar name but different email ids. 
select distinct s.sname from student s
join student st on s.sname=st.sname and s.semail<>st.semail

#22)Display the course name fetching the 2nd highest revenue. 
select * from (select coursename,sum(c.coursefees)as total from course c 
join batch b on b.courseid=c.courseid
join enrollment e on e.batchid=b.batchid
join student s on s.sid=e.sid
group by coursename
order by total desc
limit 2) as T
order by T.total asc
limit 1;

#23) Which among the following have the highest enrollment? (Graduate,Undergraduate or  postgraduate).
select squal as Qualification,count(*) as HighestEnrollnmet from student s
join enrollment e on s.sid=e.sid
group by Qualification
	
#24) Display student name, age[Alias] , coursename, batchid, batch_start_ date, batch_ end _date 
#and enrollment date in the format 1st of Jan , 2012 .
select s.sname,timestampdiff(year,s.sdob,curdate()) as age,c.coursename,b.batchid,date(b.bsdate) as batch_start_date,date(bsdate+interval c.courseduration day) as batch_end_date from course c
join batch b on b.courseid=c.courseid
join enrollment e on e.batchid=b.batchid
join student s on s.sid=e.sid;
