create table shownumbers (
	shownumber int,
	primary key(shownumber)
);

create table rounds (
	round varchar(150),
	primary key(round)
);

create table categories (
	category varchar(250),
	primary key(category)
);

create table jeopardy (
	id Serial,
	shownumber int references shownumbers(shownumber),
	airdate varchar(250),
	rounds varchar(150) references rounds(round),
	categories varchar(250) references categories(category),
	valueindollars int,
	question varchar,
	answer varchar,
	primary key(id)
);

create table questionnouns (
	id Serial,
	questionnoun varchar,
	jeopardyId int,
	primary key(id)
);

create table answernouns (
	id Serial,
	answernoun varchar,
	jeopardyId int,
	primary key(id)
);

create table persons (
	person varchar(250),
	gender varchar(50),
	primary key(person)
);

create table sentiments (
	id Serial,
	polarity decimal,
	subjectivity decimal,
	jeopardyId int,
	primary key(id)
);

create table creeps (
	name varchar(250),
	primary key(name)
);