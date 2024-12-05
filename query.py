import os
import sys

from dotenv import load_dotenv
import psycopg


load_dotenv()

DB_PASSWORD = os.getenv("DB_PASSWORD")


def query(*args):
    conn = psycopg.Connection.connect(
        host="localhost",
        port=5433,
        user="postgres",
        password=DB_PASSWORD,
    )
    query = """
        SELECT l.id
        FROM listings l
        JOIN listing_tags lt ON l.id = lt.listing_id
        JOIN tags t ON lt.tag_id = t.id
        WHERE t.name = ANY(%s)
        GROUP BY l.id
        HAVING COUNT(DISTINCT t.name) = %s;
    """
    params = (list(args), len(args))

    with conn.cursor() as cur:
        cur.execute(query, params)
        rows = cur.fetchall()
        print(rows)


if __name__ == "__main__":
    query(*sys.argv[1:])
