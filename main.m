clear; close; clc;

% Final bot: @SmartMatEcho_bot
% Made by Abtin Aghasadeghi
%%%%%%%%%%%%%%%%%%%%% START %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We save our bot api token below
BotToken = 'Your Token';

% We have to define telegram api url
TgURL = 'https://api.telegram.org/bot';

% We define a command just to check if our bot exist or not.
cmd = 'getme'; % getme/getUpdates

% Now we combine these variables in order to make our full URL
URLMatris = [TgURL, BotToken, '/'];

% We can change webread options below
Options = weboptions('ArrayFormat', 'json', 'CharacterEncoding', 'UTF-8');

% We do a web request just to see if everything's going well
GTM = webread([URLMatris, cmd], Options);
if  (GTM.ok ~= true)
    error('Failed to connect...');
end

% Now we set new cmd to get updates from our bot
cmd = 'getUpdates';
UPD = webread([URLMatris, cmd], Options);

status = true; % define a status variable for while loop

while status

    cmd = 'getUpdates';
    UPDS = webread([URLMatris, cmd], Options);
    % Number of new messages
    NOM = size(UPDS.result, 1);
    if NOM ~= 0
        ChatId = UPDS.result(1).message.chat.id; % read chat id
        txt = UPDS.result(1).message.text; % read the text
        cmd = 'sendMessage';
        Check = webread([URLMatris, cmd],...
            'chat_id', num2str(ChatId),... % value pair for chat id
            'text', txt, Options); % value pair for the text

        if Check.ok %if sending was successfull

            UID = UPDS.result(1).update_id; % read the update Id
            cmd = 'getUpdates';
            webread([URLMatris,cmd], 'offset', num2str (UID+1),...
                Options); % Telegram forgets all those messages.
        end;
    end;
    pause(1); % Pause for a second to prevent over flow and manage traffic 
    disp('Waiting for messages')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%