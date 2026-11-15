.PHONY: unzip generate verify cross_verify

unzip:
	unzip -o artifacts_jose_cose_v1.zip

generate:
	./gen.sh

verify:
	./check.sh artifacts_jose_cose_v1 compatMatrices/artifacts_jose_cose_v1/huawei_huawei.csv

# usage: make cross_verify DIR=../other-provider/artifacts_jose_cose_v1 PRODUCER=other-provider
cross_verify:
	./check.sh $(DIR) compatMatrices/artifacts_jose_cose_v1/$(PRODUCER)_huawei.csv
