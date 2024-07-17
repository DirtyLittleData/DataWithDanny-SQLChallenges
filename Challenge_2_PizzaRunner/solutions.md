**Schema (PostgreSQL v13)**

---
**Question #1**
How many pizzas were ordered?

'''sql
    SELECT 
        COUNT(order_id)
    FROM Customer_orders;
'''

#### Solution:
| count |
| ----- |
| 14    |

---
