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

create table persons (
	person varchar(250),
	gender varchar(50),
	primary key(person)
);