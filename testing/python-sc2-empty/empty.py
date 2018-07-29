import random

import sc2
from sc2 import Race, Difficulty
from sc2.constants import *
from sc2.player import Bot, Computer

class EmptyBot(sc2.BotAI):
    def __init__(self):
        pass

    async def on_step(self, iteration):
        return

def main():
    sc2.run_game(sc2.maps.get("Abyssal Reef LE"), [
        Bot(Race.Zerg, ZergRushBot()),
        Computer(Race.Terran, Difficulty.Medium)
    ], realtime=False, save_replay_as="ZvT.SC2Replay")

if __name__ == '__main__':
    main()
