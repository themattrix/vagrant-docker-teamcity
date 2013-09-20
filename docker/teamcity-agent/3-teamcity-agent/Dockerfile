FROM mattrix/teamcity-agent-depends

# Expose the default TeamCity Agent port
EXPOSE 9090:9090

# Add agent runner which sets its config before running
ADD agent.sh $TEAM_CITY_INSTALL_DIR/TeamCity/bin/

# Ensure the hostname can be resolved and start the TeamCity Agent
ENTRYPOINT ["/usr/local/TeamCity/bin/agent.sh"]
