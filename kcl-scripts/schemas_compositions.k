schema StaticWebsiteSpec:
 bucketName: str
 domainName: str
 indexDocument: str = "index.html"
 errorDocument: str = "404.html"
 enableCaching: bool = True
 cacheTTL: int = 3600
 tags: {str: str} = {}
schema StaticWebsiteStatus:
 bucketArn: str = ""
 distributionId: str = ""
 distributionDomain: str = ""
 ready: bool = False
