%
% Copyright (c) 2016 Petr Gotthard <petr.gotthard@centrum.cz>
% All rights reserved.
% Distributed under the terms of the MIT License. See the LICENSE file.
%
%
-module(lorawan_application_stm32l152re_status).
-behaviour(lorawan_application).

-export([init/1, handle_join/3, handle_rx/4]).

-include_lib("lorawan_server_api/include/lorawan_application.hrl").

init(_App) ->
    ok.

handle_join(_LinkAddr, _App, _AppID) ->
    % accept any device
    ok.

% the data structure is explained in
% FIXME
handle_rx(DevAddr, _App, _AppID, #rxdata{port=2, data= <<LED:8/integer, Batt:8/integer, $#, Payload/binary >>}) ->
    lager:debug("PUSH_DATA DevAddr:~w LED:~w Batt:~w% Payload:~w",[DevAddr, LED, (Batt*100 div 255), Payload]),
    % blink with the LED indicator
    {send, #txdata{port=2, data= <<((LED + 1) rem 2)>>}};

handle_rx(DevAddr, _App, AppID, #rxdata{last_lost=true}) ->
    retransmit;

handle_rx(_LinkAddr, _App, _AppID, RxData) ->
    lager:debug("[stm32l152re_status::handle_rx] ~w ~w ~w ~w",[_LinkAddr, _App, _AppID, RxData]),
    {error, {unexpected_data, RxData}}.

% end of file
