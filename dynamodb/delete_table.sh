#!/bin/bash
TABLENAME="movies"
echo "Deleting table $TABLENAME"
aws dynamodb delete-table \
	--table-name "$TABLENAME"
