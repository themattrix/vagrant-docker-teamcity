FROM mattrix/teamcity-agent-dind

# Expose the default TeamCity Agent port
EXPOSE 9090

# Add agent runner which sets its config before running
ADD agent.sh $TEAM_CITY_INSTALL_DIR/TeamCity/bin/
RUN chmod u+x $TEAM_CITY_INSTALL_DIR/TeamCity/bin/agent.sh

# Ensure the hostname can be resolved and start the TeamCity Agent
ENTRYPOINT ["/usr/local/TeamCity/bin/agent.sh"]
