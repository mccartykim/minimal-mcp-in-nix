#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#     "mcp",
# ]
# ///

from mcp.server.fastmcp import FastMCP
import datetime

mcp = FastMCP("Honk TTS")

@mcp.tool()
def getDateTime() -> dict:
    """Use the MacOS tts to say things"""
    return {'datetime': datetime.datetime.now() }

def main():
    mcp.run()

if __name__ == "__main__":
    main()
