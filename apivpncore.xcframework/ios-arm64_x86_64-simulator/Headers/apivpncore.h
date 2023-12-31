#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/**
 * Gets the last error.
 */
int32_t apivpn_last_error(void);

/**
 * Initializes the SDK with an application token, an API server address and a
 * writable metadata folder. The SDK must be successfully initialized to call any
 * subsequent functions.
 *
 * If an empty string has specified as the API server address, the default server
 * `api.devop.pw` will apply.
 */
int32_t apivpn_init(const char *app_token, const char *api_server, const char *data_dir);

/**
 * Returns a list of available servers as a serialized JSON string. The returned
 * string must be freed by calling `apivpn_servers_free`.
 */
char *apivpn_servers(void);

/**
 * Frees string allocated by `apivpn_servers`.
 */
void apivpn_servers_free(char *p);

/**
 * Returns the path to the connection log file.
 *
 * The log file contains information about completed connections of the current
 * VPN session or the last VPN session, each line in the log represents a single
 * connection, in JSON format, here is an example of a single line:
 *
 * ```
 * {"start":1690090880,"end":1690090893,"bytes_recvd":364468,"bytes_sent":590,"host":"www.cloudflare.com","port":443,"protocol":"TCP","outbound_tag":"Proxy","rule_type":"NONE"}
 * ```
 * start: timestamp at connection created
 * end: timestamp at connection ended
 * bytes_recvd: bytes received
 * bytes_sent: bytes sent
 * host: destination host, can be domain name or IP
 * port: destination port
 * protocol: TCP or UDP
 * outbound_tag: the tag of the outbound which handles the connection
 * rule_type: type of the matched rule, possible values are:
 *   - NONE (no matching rule)
 *   - IP
 *   - GEOIP
 *   - DOMAIN
 */
char *apivpn_get_connection_log_file(void);

/**
 * Starts the VPN with a v2ray server_id and a TUN FD. The function will fetch the
 * v2ray configuration for the given server_id and apply all supported
 * features such as outbounds and routing rules containing in the configuration.
 */
int32_t apivpn_start_v2ray(int32_t server_id, int32_t tun_fd, const char *alt_rules);

/**
 * Stops the VPN.
 */
void apivpn_stop(void);

/**
 * Checks if the VPN is running.
 */
bool apivpn_is_running(void);

/**
 * Sets the asset location.
 */
void apivpn_set_asset_location(const char *path);
