import psycopg2
import pandas as pd
# import seaborn as sns
import random

class DataResource(object):

    def __init__(self):
        self.conn = psycopg2.connect(dbname="", user="", password="", port="", host="")
        self.count = 0

    def get_cursor(self):
        return self.conn.cursor()

    def get_cursor_name(self):
        self.count += 1
        return 'mycursor'+self.count

    def get_fighters_basics(self, fighter1, fighter2):
        cursor = self.get_cursor()
        cursor.execute("SELECT get_fighter_basics(%s, %s)",(fighter1, self.get_cursor_name()))

        cursorname = cursor.fetchone()[0]

        cursor.execute('FETCH ALL IN "%s"' % (cursorname))

        colnames = [desc[0] for desc in cursor.description]

        result = cursor.fetchall()

        df = pd.DataFrame(result)

        cursor.close()

        cursor = self.conn.cursor()

        cursor.execute("SELECT get_fighter_basics(%s, %s)",(fighter2, self.get_cursor_name()))

        cursor_name = cursor.fetchone()[0]

        cursor.execute('FETCH ALL IN "%s"' % (cursor_name))

        df.add(pd.DataFrame(cursor.fetchall()))

        cursor.close()

        df.columns = colnames

        # return df, perhaps return shape info too
        return df

