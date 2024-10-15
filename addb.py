import datetime as dt
import psycopg
import random
import time
import uuid
import string


class Addb:
    def __init__(self, args: dict):
        # args is a dict of string passed with the --args flag
        # user passed a yaml/json, in python that's a dict object

        self.read_pct: float = float(args.get("read_pct", 50) / 100)

        self.lane: str = (
            random.choice(["ACH", "DEPO", "WIRE"])
            if not args.get("lane", "")
            else args["lane"]
        )

        # you can arbitrarely add any variables you want
        self.uuid: uuid.UUID = uuid.uuid4()
        self.ts: dt.datetime = ""
        self.event: str = ""

    # the setup() function is executed only once
    # when a new executing thread is started.
    # Also, the function is a vector to receive the excuting threads's unique id and the total thread count
    def setup(self, conn: psycopg.Connection, id: int, total_thread_count: int):
        with conn.cursor() as cur:
            print(
                f"My thread ID is {id}. The total count of threads is {total_thread_count}"
            )

    # the run() function returns a list of functions
    # that dbworkload will execute, sequentially.
    # Once every func has been executed, run() is re-evaluated.
    # This process continues until dbworkload exits.
    def loop(self):
        if random.random() < self.read_pct:
            return [self.read]
        return [self.t1_insert, self.t2_update, self.txn3_finalize]

    # conn is an instance of a psycopg connection object
    # conn is set by default with autocommit=True, so no need to send a commit message
    def read(self, conn: psycopg.Connection):
        with conn.cursor() as cur:
            cur.execute(
                "select * from dly where isdeleted<100000"
            )
            records=cur.fetchone()
            #print("Total rows: ", len(records))

    def t1_insert(self, conn: psycopg.Connection):
        rando1=random.random()
        rando2=random.random()
        namo=''.join(random.choices(string.ascii_letters,k=7) )
        print("namo: ", namo)
        with conn.cursor() as cur:
            stmt = """
                INSERT INTO dly (user_login_id, end_customer_agreement_yr_ind, isdeleted) VALUES (%s, %s, %s);
                """
            cur.execute(stmt, (namo, rando1, rando2))

    # example on how to create a transaction with multiple queries
    def t2_update(self, conn: psycopg.Connection):
        end_customer_agreement_yr_ind_VALUE=random.random()
        with conn.cursor() as cur:
            stmt = """
                UPDATE dly SET end_customer_agreement_yr_ind=%s WHERE isdeleted>950000;
            """
        cur.execute(stmt, (end_customer_agreement_yr_ind_VALUE))


