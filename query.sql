SELECT
a.billsession,
a.date,
a.billtype,
a.description,
a.result,

COUNT(a.vote) AS totalvotes,

#sum(case when a.vote = "+" then 1 else 0 end) AS `yes`,
sum(case when b.party = "Democrat" AND a.vote = "+" then 1 else 0 end) AS `yes_democrats`,
sum(case when b.party = "Republican" AND a.vote = "+" then 1 else 0 end) AS `yes_republicans`,
sum(case when b.party NOT IN("Democrat", "Republican") AND a.vote = "+" then 1 else 0 end) AS `yes_independent`,

#sum(case when a.vote = "-" then 1 else 0 end) AS `no`,
sum(case when b.party = "Democrat" AND a.vote = "-" then 1 else 0 end) AS `no_democrats`,
sum(case when b.party = "Republican" AND a.vote = "-" then 1 else 0 end) AS `no_republicans`,
sum(case when b.party NOT IN("Democrat", "Republican") AND a.vote = "-" then 1 else 0 end) AS `no_independent`,

#sum(case when a.vote = "0" OR "P" OR "X" then 1 else 0 end) AS `abstain`,
sum(case when b.party = "Democrat" AND a.vote = "0" OR "P" OR "X" then 1 else 0 end) AS `abstain_democrats`,
sum(case when b.party = "Republican" AND a.vote = "0" OR "P" OR "X" then 1 else 0 end) AS `abstain_republicans`,
sum(case when b.party NOT IN("Democrat", "Republican") AND a.vote = "0" OR "P" OR "X" then 1 else 0 end) AS `abstain_independent`

FROM (SELECT
votes.id,
people_votes.personid,
votes.date,
votes.seq,
votes.description,
votes.result,
votes.billsession,
votes.billtype,
people_votes.vote

FROM votes
JOIN people_votes ON people_votes.voteid = votes.id 

WHERE votes.billsession = 112
GROUP BY votes.id,
people_votes.personid) a join people_roles b on a.personid = b.personid
where a.date between b.startdate and b.enddate
GROUP BY a.id
;
