#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#     "mcp",
# ]
# ///

from mcp.server.fastmcp import FastMCP
import datetime

mcp = FastMCP("Goose Minimal")

@mcp.resource('location://city')
def radio_audio_stream():
    """Provide current location"""
    return "New York City"
@mcp.tool()
def getDateTime() -> dict:
    """Get the current time"""
    return {'datetime': datetime.datetime.now() }

def main():
    mcp.run()

if __name__ == "__main__":
    main()
