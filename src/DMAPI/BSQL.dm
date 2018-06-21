//BSQL - DMAPI v1.2.0.0

//types of connections
#define BSQL_CONNECTION_TYPE_MARIADB "MySql"
#define BSQL_CONNECTION_TYPE_SQLSERVER "SqlServer"

//special parameters
#define BSQL_SQLSERVER_USE_INTEGRATED_SECURITY "ok_but_if_someone_in_the_byond_community_actually_makes_this_their_username_they_deserve_to_fail_with_this"

//Call this before rebooting or shutting down your world to clean up gracefully. This invalidates all active connection and operation datums
/world/proc/BSQL_Shutdown()
	return

/*
Called whenever a library call is made with verbose information, override and do with as you please
  message: English debug message
*/
/world/proc/BSQL_Debug(msg)
	return

/*
Create a new database connection, does not perform the actual connect
  connection_type: The BSQL connection_type to use
*/
/datum/BSQL_Connection/New(connection_type)
	return ..()

/*
Starts an operation to connect to a database. Should only have 1 successful call. If it fails the entire connection must be discarded
  ipaddress: The ip/hostname of the target server. If using BSQL_SQLSERVER_USE_INTEGRATED_SECURITY must be in the form <server name>\<instance name>
  port: The port of the target server
  username: The username to login to the target server. If called on an SQL Server connection, BSQL_SQLSERVER_USE_INTEGRATED_SECURITY may be used to use windows authentication
  password: The password for the target server. If using BSQL_SQLSERVER_USE_INTEGRATED_SECURITY this parameter is ignored
  database: Optional database to connect to. Must be used when trying to do database operations, `USE x` is not sufficient
 Returns: A /datum/BSQL_Operation representing the connection or null if an error occurred
*/
/datum/BSQL_Connection/proc/BeginConnect(ipaddress, port, username, password, database)
	return

/*
Properly quotes a string for use by the database. The connection must be open for this proc to succeed
  str: The string to quote
 Returns: The string quoted on success, null on error
*/
/datum/BSQL_Connection/proc/Quote(str)
	return

/*
Starts an operation for a query
  query: The text of the query. Only one query allowed per invocation, no semicolons
 Returns: A /datum/BSQL_Operation/Query representing the running query and subsequent result set or null if an error occurred

 Note for MariaDB: The underlying connection is pooled. In order to use connection state based properties (i.e. LAST_INSERT_ID()) you can guarantee multiple queries will use the same connection by running BSQL_DEL_CALL(query) on the finished /datum/BSQL_Operation/Query and then creating the next one with another call to BeginQuery() with no sleeps in between

 Note for SqlServer: There is a maximum number of concurrent queries defined by the driver. Query operations will remain running until they can allocate a handle under this limit. Always clean up finished or unused query objects ASAP
*/
/datum/BSQL_Connection/proc/BeginQuery(query)
	return

/*
Checks if the operation is complete. This, in some cases must be called multiple times with false return before a result is present regardless of timespan. For best performance check it once per tick

 Returns: TRUE if the operation is complete, FALSE if it's not, null on error
*/
/datum/BSQL_Operation/proc/IsComplete()
	return

/*
Blocks the entire game until the given operation completes. IsComplete should not be checked after calling this to avoid potential side effects
*/
/datum/BSQL_Operation/proc/WaitForCompletion()
	return

/*
Get the error message associated with an operation. Should not be used while IsComplete() returns FALSE

 Returns: The error message, if any. null otherwise
*/
/datum/BSQL_Operation/proc/GetError()
	return

/*
Get the error code associated with an operation. Should not be used while IsComplete() returns FALSE

 Returns: The error code, if any. null otherwise

Note for SqlServer: Errors are returned as 5 character strings
*/
/datum/BSQL_Operation/proc/GetErrorCode()
	return

/*
Gets an associated list of column name -> value representation of the most recent row in the query. Only valid if IsComplete() returns TRUE. If this returns null and no errors are present there are no more results in the query. Important to note that once IsComplete() returns TRUE it must not be called again without checking this or the row values may be lost

 Returns: An associated list of column name -> value for the row. Values will always be either strings or null
*/
/datum/BSQL_Operation/Query/proc/CurrentRow()
	return


/*
Code configuration options below

Define this to avoid modifying this file but the following defines must be declared somewhere else before BSQL/includes.dm is included
*/
#ifndef BSQL_EXTERNAL_CONFIGURATION

//Modify this if you disagree with byond's GC schemes. Ensure this is called for all connections and operations when they are deleted or they will leak native resources until /world/proc/BSQL_Shutdown() is called
#define BSQL_DEL_PROC(path) ##path/Del()

//The equivalent of calling del() in your codebase
#define BSQL_DEL_CALL(obj) del(##obj)

//Returns TRUE if an object is delete
#define BSQL_IS_DELETED(obj) (obj == null)

//Modify this to add protections to the connection and query datums
#define BSQL_PROTECT_DATUM(path)

//Modify this to change up error handling for the library
#define BSQL_ERROR(message) CRASH("BSQL: [##message]")

#endif

/*
Copyright 2018 Jordan Brown

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
