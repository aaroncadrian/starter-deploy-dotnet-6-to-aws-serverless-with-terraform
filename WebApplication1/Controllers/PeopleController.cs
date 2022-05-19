using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.Model;
using Microsoft.AspNetCore.Mvc;

namespace WebApplication1.Controllers;

[ApiController]
[Route("[controller]")]
public class PeopleController : ControllerBase
{
    private readonly IAmazonDynamoDB _dynamoDb;

    private readonly IConfiguration _configuration;

    public PeopleController(IConfiguration configuration, IAmazonDynamoDB dynamoDb)
    {
        _configuration = configuration;
        _dynamoDb = dynamoDb;
    }

    [HttpGet]
    public async Task<IActionResult> GetPeople(CancellationToken cancellationToken)
    {
        var tableName = _configuration.GetValue<string>("PRIMARY_DYNAMO_TABLE_NAME");

        var queryRequest = new QueryRequest(tableName)
        {
            KeyConditionExpression = "#pk = :pk",
            ExpressionAttributeNames = new Dictionary<string, string>
            {
                {"#pk", "pk"}
            },
            ExpressionAttributeValues = new Dictionary<string, AttributeValue>
            {
                {":pk", new AttributeValue("PEOPLE")}
            }
        };

        var result = await _dynamoDb.QueryAsync(queryRequest, cancellationToken);

        var items = result.Items.Select(item => new
        {
            pk = item.GetValueOrDefault("pk")?.S,
            sk = item.GetValueOrDefault("sk")?.S,
            firstName = item.GetValueOrDefault("firstName")?.S,
            lastName = item.GetValueOrDefault("lastName")?.S
        });

        return Ok(new
        {
            tableName,
            items
        });
    }
}