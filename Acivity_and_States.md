{\rtf1\ansi\ansicpg1252\cocoartf2513
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{decimal\}.}{\leveltext\leveltemplateid1\'02\'00.;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listlevel\levelnfc4\levelnfcn4\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{lower-alpha\}.}{\leveltext\leveltemplateid2\'02\'01.;}{\levelnumbers\'01;}\fi-360\li1440\lin1440 }{\listlevel\levelnfc2\levelnfcn2\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{lower-roman\}.}{\leveltext\leveltemplateid3\'02\'02.;}{\levelnumbers\'01;}\fi-360\li2160\lin2160 }{\listname ;}\listid1}
{\list\listtemplateid2\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{decimal\}.}{\leveltext\leveltemplateid101\'02\'00.;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listlevel\levelnfc4\levelnfcn4\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{lower-alpha\}.}{\leveltext\leveltemplateid102\'02\'01.;}{\levelnumbers\'01;}\fi-360\li1440\lin1440 }{\listname ;}\listid2}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}{\listoverride\listid2\listoverridecount0\ls2}}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\ri-340\partightenfactor0

\f0\fs24 \cf0 Activity Process of Lift\
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls1\ilvl0\cf0 1.	Arrive at lift\
2.	Press button to call lift. \
\pard\pardeftab720\li1440\fi-360\ri-340\partightenfactor0
\ls1\ilvl1\cf0 a.	In doing so you press up/down.\
\pard\pardeftab720\li2160\fi-180\ri-340\partightenfactor0
\ls1\ilvl2\cf0 i.	This lets the lift plan ahead to know which stops to go too. \
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls1\ilvl2\cf0 3.	Lift arrives. \
4.	Doors open. \
5.	You go in. \
6.	Lift runs object detection. \
\pard\pardeftab720\li1440\fi-360\ri-340\partightenfactor0
\ls1\ilvl1\cf0 a.	If no one in the way. Doors close. \
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls1\ilvl1\cf0 7.	Once doors close. \
8.	Lift goes to floor.\
9.	Someone on a different floor calls lift. \
\pard\pardeftab720\li1440\fi-360\ri-340\partightenfactor0
\ls1\ilvl1\cf0 a.	In doing so press up/down. \
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls1\ilvl1\cf0 10.	Lift continues to its destination from previous user. \
11.	Once at destination, lift calculates most efficient route that includes picking up any new users (that may put in a new floor). \
\pard\pardeftab720\li1440\fi-360\ri-340\partightenfactor0
\ls1\ilvl1\cf0 a.	This part of logic. \
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls1\ilvl1\cf0 12.	Left arrives at next floor. \
\pard\pardeftab720\li1440\fi-360\ri-340\partightenfactor0
\ls1\ilvl1\cf0 a.	Repeats process. \
\pard\pardeftab720\ri-340\partightenfactor0
\cf0 \
States of lift:\
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls2\ilvl1\cf0 1.	Moving up\
\pard\pardeftab720\li1440\fi-360\ri-340\partightenfactor0
\ls2\ilvl1\cf0 a.	Does shall not open/close\
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls2\ilvl1\cf0 2.	Moving down\
\pard\pardeftab720\li1440\fi-360\ri-340\partightenfactor0
\ls2\ilvl1\cf0 a.	Doors shall not open/close\
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls2\ilvl1\cf0 3.	Idle (when at floor)\
\pard\pardeftab720\li1440\fi-360\ri-340\partightenfactor0
\ls2\ilvl1\cf0 a.	Doors can open\
b.	Doors can close\
\pard\pardeftab720\li720\fi-360\ri-340\partightenfactor0
\ls2\ilvl1\cf0 4.	Emergency\
}