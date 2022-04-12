<div style="text-align:right; font-size:3em;">2021.03.03</div>

sql和nosql的区别

在知乎的一个回答https://zhuanlan.zhihu.com/p/78619241

是否是固定的区别。“sql是二维表格”还是太限制思考了，因为表格嵌套十分不好思考。

NoSQL提出了另一种理念，以键值来存储，且结构不稳定，每一个元组都可以有不一样的字段，这种就不会局限于固定的结构，可以减少一些时间和空间的开销。使用这种方式，为了获取用户的不同信息，不需要像关系型数据库中，需要进行多表查询。仅仅需要根据key来取出对应的value值即可。

---

看完了https://www.tutorialrepublic.com/sql-tutorial/sql-get-started.php的SQL BASIC和SQL JOINS感觉SQL好无聊啊，就是CLI表格程序嘛。

---

SQL无法简单地存储变长数组https://stackoverflow.com/questions/3070384/how-to-store-a-list-in-a-column-of-a-database-table

说明这个数据结构不适合我的想法，放指针链表。

<div style="text-align:right; font-size:3em;">2021.03.04</div>

https://en.wikipedia.org/wiki/Database#Database_management_system

DBMS列举了3类（不局限于这3类），R, OO, OR

> The DBMS acronym is sometimes extended to indicate the underlying [database model](https://en.wikipedia.org/wiki/Database_model), with RDBMS for the [relational](https://en.wikipedia.org/wiki/Relational_model), OODBMS for the [object (oriented)](https://en.wikipedia.org/wiki/Object_model) and ORDBMS for the [object-relational model](https://en.wikipedia.org/wiki/Object-relational_database). Other extensions can indicate some other characteristic, such as DDBMS for a distributed database management systems.

我想要的大概就是[OR](https://en.wikipedia.org/wiki/Object%E2%80%93relational_database)吧。希望OR能够有链表（list）的概念。应该也没有。

---

仔细想想，确实链表这种结构不适合存在定长的表格单元里。正确的做法应该是分为两类表，点和边！

数据库和图形库分开！比如sql配合d3.js。

