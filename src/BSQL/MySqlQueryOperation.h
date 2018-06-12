#pragma once

class MySqlQueryOperation : public Query {
private:
	const std::string queryText;
	MySqlConnection& connPool;
	MYSQL* connection;
	MYSQL_RES* result;
	MYSQL_ROW row;
	std::chrono::milliseconds timeoutAt;
	int queryError, connectFailCount, status;
	bool complete, queryFinished, waitNext;
private:
	void StartQuery();
public:
	MySqlQueryOperation(MySqlConnection& connPool, std::string&& queryText);
	~MySqlQueryOperation() override;

	bool IsComplete(bool noOps) override;
};
