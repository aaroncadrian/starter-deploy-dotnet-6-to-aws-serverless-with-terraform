using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DocumentModel;
using Microsoft.AspNetCore.Mvc;

namespace WebApplication1.Controllers;

[ApiController]
[Route("[controller]")]
public class PeopleController : ControllerBase
{
    private readonly IAmazonDynamoDB _dynamoDb;

    private readonly IConfiguration _configuration;

    public PeopleController(IAmazonDynamoDB dynamoDb, IConfiguration configuration)
    {
        _dynamoDb = dynamoDb;
        _configuration = configuration;
    }

    [HttpGet]
    public async Task<IActionResult> GetPeople(CancellationToken cancellationToken)
    {
        var tableName = _configuration.GetValue<string>("PRIMARY_DYNAMO_TABLE_NAME");
        
        var table = Table.LoadTable(_dynamoDb, tableName);

        var scan = table.Scan(new ScanOperationConfig());

        var result = await scan.GetNextSetAsync(cancellationToken);

        return Ok(new
        {
            Items = result
        });
    }
}