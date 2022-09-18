from chessdotcom import get_player_game_archives, get_country_players, get_player_stats
import numpy as np
import pandas as pd
import requests
import time
import re



# GET PLAYERS

# Get usernames by country
def get_country_usernames(country):
    time.sleep(5)
    names = get_country_players(country).json
    players = names['players'][:100]
    userlist = []
    for player in players:
        try:
            userlist.append(player)
        except:
            pass
    return userlist

countries = ['CN', 'IN', 'US', 'ID', 'CA', 
             'BR', 'NG', 'BD', 'RU', 'JP', 
             'MX', 'ET', 'PH', 'EG', 'VN', 
             'CD', 'DE', 'TR', 'IR', 'TH',
             'FR', 'GB', 'IT', 'ES', 'AR']
players = []

for country in countries:
    players += get_country_usernames(country)
    
    
# PLAYER STATS

def get_stats(player):
    time.sleep(5)
    try:
        stats = get_player_stats(player).json['stats']
        # Rapid
        if 'chess_rapid' in stats.keys():
            rapid = stats['chess_rapid']
            rapid_rating = rapid['last']['rating']
            rapid_wins = rapid['record']['win']
            rapid_losses = rapid['record']['loss']
            rapid_draws = rapid['record']['draw']
        else:
            rapid_rating = None
            rapid_wins = None
            rapid_losses = None
            rapid_draws = None
        # Blitz
        if 'chess_blitz' in stats.keys():
            blitz = stats['chess_blitz']
            blitz_rating = blitz['last']['rating']
            blitz_wins = blitz['record']['win']
            blitz_losses = blitz['record']['loss']
            blitz_draws = blitz['record']['draw']
        else:
            blitz_rating = None
            blitz_wins = None
            blitz_losses = None
            blitz_draws = None
        # Bullet
        if 'chess_bullet' in stats.keys():
            bullet = stats['chess_bullet']
            bullet_rating = bullet['last']['rating']
            bullet_wins = bullet['record']['win']
            bullet_losses = bullet['record']['loss']
            bullet_draws = bullet['record']['draw']
        else:
            bullet_rating = None
            bullet_wins = None
            bullet_losses = None
            bullet_draws = None
        # Tactics
        if 'tactics' in stats.keys():
            if 'highest' in stats['tactics'].keys():
                tactics_rating = stats['tactics']['highest']['rating']
            else: tactics_rating = None
        else:
            tactics_rating = None
            
        # Puzzle Rush
        if 'puzzle_rush' in stats.keys():
            if 'best' in stats['puzzle_rush'].keys():
                rush_rating = stats['puzzle_rush']['best']['score']
            else:
                rush_rating = None
        else:
            rush_rating = None
        
        return [rapid_rating, rapid_wins, rapid_losses, rapid_draws, blitz_rating, 
                blitz_wins, blitz_losses, blitz_draws, bullet_rating, 
                bullet_wins, bullet_losses, bullet_draws, tactics_rating, rush_rating]
    except:
        return [None] * 14



# GAME STATS

# Last game of user
def get_player_game(username):
    time.sleep(5)
    try:
        data = get_player_game_archives(username).json
        url = data['archives'][-1]
        games = requests.get(url).json()
        game = games['games'][-1]
        
        # ID
        gameID = game['url'].split("/")[-1]

        
        # Opening and Moves
        if 'pgn' in game.keys():
            pgn = game['pgn']
            
            
            #m_start = pgn.find("\n\n") + 3
            #moves = pgn[m_start:-6]
        else:
            pgn = None
        
        
        # Time Control
        if 'time_control' in game.keys():
            tc = game['time_control']
        else:
            tc = None
        
        # Time Class
        if 'time_class' in game.keys():
            timeclass = game['time_class']
        else:
            timeclass = None
        
        # Accuracies
        if 'accuracies' in game.keys():
            w_accuracy = game['accuracies']['white']
            b_accuracy = game['accuracies']['black']
        else:
            w_accuracy = None
            b_accuracy = None
            
        # Ratings
        w_rating = game['white']['rating']
        b_rating = game['black']['rating']
        
        # Result
        w_result = game['white']['result']
        b_result = game['black']['result']
        
        # Users
        w_user = game['white']['username']
        b_user = game['black']['username']
        
        # User stats
        w = get_stats(w_user)  
        b = get_stats(b_user)
        
        return [gameID, pgn, tc, timeclass, w_accuracy, b_accuracy, 
                w_rating, b_rating, w_result, b_result, w_user, 
                b_user, w, b]
    except:
        return [None] * 14
        
    

# CREATE DATAFRAME

df = pd.DataFrame(columns = ['gameID', 'pgn', 'tc', 'timeclass', 'w_accuracy',
                             'b_accuracy', 'w_rating', 'b_rating', 'w_result',
                             'b_result', 'w_user', 'b_user', 
                             'w_rapid_wins', 'w_rapid_losses', 'w_rapid_draws',
                             'w_blitz_rating', 'w_blitz_wins', 'w_blitz_losses', 
                             'w_blitz_draws', 'w_bullet_rating', 'w_bullet_wins', 
                             'w_bullet_losses', 'w_bullet_draws', 'w_tactics_rating',
                             'w_rush_rating', 'b_rapid_rating', 'b_rapid_wins', 
                             'b_rapid_losses', 'b_rapid_draws', 'b_blitz_rating', 
                             'b_blitz_wins', 'b_blitz_losses', 'b_blitz_draws', 
                             'b_bullet_rating', 'b_bullet_wins', 'b_bullet_losses', 
                             'b_bullet_draws', 'b_tactics_rating', 'b_rush_rating'])

for player in players:
    try:
        g = get_player_game(player)
        w = g[12]
        b = g[13]
        df = df.append({'gameID': g[0], 'pgn': g[1], 'tc': g[2], 'timeclass': g[3],
                                    'w_accuracy': g[4], 'b_accuracy': g[5], 'w_rating': g[6],
                                    'b_rating': g[7], 'w_result': g[8], 'b_result': g[9],
                                    'w_user': g[10], 'b_user': g[11], 'w_rapid_rating': w[0], 
                                    'w_rapid_wins': w[1], 'w_rapid_losses': w[2], 
                                    'w_rapid_draws': w[3], 'w_blitz_rating': w[4], 
                                    'w_blitz_wins': w[5], 'w_blitz_losses': w[6], 
                                    'w_blitz_draws': w[7], 'w_bullet_rating': w[8], 
                                    'w_bullet_wins': w[9], 'w_bullet_losses': w[10], 
                                    'w_bullet_draws': w[11], 'w_tactics_rating': w[12], 
                                    'w_rush_rating': w[13], 'b_rapid_rating': b[0], 
                                    'b_rapid_wins': b[1], 'b_rapid_losses': b[2], 
                                    'b_rapid_draws': b[3], 'b_blitz_rating': b[4], 
                                    'b_blitz_wins': b[5], 'b_blitz_losses': b[6], 
                                    'b_blitz_draws': b[7], 'b_bullet_rating': b[8], 
                                    'b_bullet_wins': b[9], 'b_bullet_losses': b[10], 
                                    'b_bullet_draws': b[11], 'b_tactics_rating': b[12],
                                    'b_rush_rating': b[13]},
                                    ignore_index = True)
    except:
        pass
    


df['moves'] = df['pgn']
df['opening'] = df['pgn']

# Add moves and openings from PGN

for i in range(2387):
    if df['pgn'][i] is not None:
        pgn = df['pgn'][i]
        pgn = pgn.replace(",", "")
        pgn = pgn.replace(";", "")
        pgn = pgn.replace("\t", "")
        pgn = pgn.replace(":", "")
        pgn = pgn.replace("|", "")
        pgn = pgn.replace('"', '')
        
        # Moves
        m_start = pgn.find("\n\n") + 2
        m_end = pgn[m_start:].find("\n")
        moves = pgn[m_start:m_start+m_end]
        df['moves'][i] = re.sub('{.*?}', '', str(moves))
        
        # Openings
        o_start = pgn.find("openings/") + 9
        o_end = pgn[o_start:].find(']\n')
        df['opening'][i] = pgn[o_start:o_start+o_end]
        
        
    else:
        df['moves'][i] = None
        df['opening'][i] = None
    
    
chess_games = df.drop(['pgn'], axis=1)
chess_games = chess_games.fillna("NULL")

# Create CSV
chess_games.to_csv('chess_games.csv')
    
    
    
    
    
