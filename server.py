from mcp.server.fastmcp import FastMCP
import datetime

mcp = FastMCP("Goose Minimal")

@mcp.resource('location://city')
def get_location():
    """Provide current location"""
    return "New York City"
@mcp.tool()
def get_date_time() -> dict:
    """Get the current time"""
    return {'datetime': datetime.datetime.now() }

def main():
    mcp.run()

if __name__ == "__main__":
    main()
