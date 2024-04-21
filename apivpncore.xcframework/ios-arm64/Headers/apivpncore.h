#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/**
 * Gets the last error.
 */
int32_t apivpn_last_error(void);

/**
 * Starts the TON proxy. The TON proxy must be started to make network requests to
 * the API server.
 */
int32_t apivpn_start_ton_proxy(void);

/**
 * Stops the TON proxy.
 */
void apivpn_stop_ton_proxy(void);

/**
 * Gets the TON proxy listening port. Returns 0 if TON proxy is not started.
 */
uint16_t apivpn_get_ton_proxy_listening_port(void);

/**
 * Sets the TON proxy server address.
 */
int32_t apivpn_set_ton_proxy_address(const char *addr);

/**
 * Sets whether to use TON proxy for API requests.
 */
void apivpn_set_is_use_ton_proxy(bool v);

/**
 * Sets the API server address.
 *
 * Default `https://api.devop.pw`
 */
void apivpn_set_api_server(const char *api_server);

/**
 * Initializes the SDK with an application token and a writable metadata folder.
 * The SDK must be successfully initialized to call any subsequent functions.
 */
int32_t apivpn_init(const char *app_token, const char *data_dir);

/**
 * Returns a list of available servers as a serialized JSON string.
 *
 * When `ping` is true, the returned servers would contain a non-NULL ping value, 0
 * ping indicates a timeout, when `ping` is false, a NULL ping value would be set.
 *
 * Default ping timeout is 1500 ms.
 *
 * The returned string must be freed by calling `apivpn_free_string`.
 *
 * JSON example
 *
 * [
 *     {
 *         "id": 227,
 *         "ip": "216.238.80.197",
 *         "exit": "216.238.80.197",
 *         "name": "El Marques",
 *         "icon": "/flags/MX.png",
 *         "hostname": "mx1-dvpn.apivpn.dev",
 *         "location": "Mexico",
 *         "latitude": 39.9643,
 *         "longitude": -75.1444,
 *         "premium": true,
 *         "country": {
 *             "code": "MX",
 *             "name": "Mexico"
 *         },
 *         "sort": 0,
 *         "pin": false,
 *         "group_id": null,
 *         "group": [
 *             {
 *                 "name": "residential"
 *             }
 *         ],
 *         "tag": [
 *             {
 *                 "name": "ws"
 *             }
 *         ],
 *         "ping": 33
 *     }
 * ]
 */
char *apivpn_servers(bool ping);

/**
 * Returns global statistics as JSON.
 *
 * JSON example
 *
 * {
 *     "total_proxy_bytes_recvd": 2743405,
 *     "total_proxy_bytes_sent": 663,
 *     "proxy_bytes_recvd_per_second": 548681,
 *     "proxy_bytes_sent_per_second": 67,
 *     "total_nonproxy_bytes_recvd": 0,
 *     "total_nonproxy_bytes_sent": 0,
 *     "nonproxy_bytes_recvd_per_second": 0,
 *     "nonproxy_bytes_sent_per_second": 0
 * }
 *
 * The returned string must be freed by calling `apivpn_free_string`.
 */
char *apivpn_get_global_statistics(void);

/**
 * Frees string allocated by the lib.
 */
void apivpn_free_string(char *p);

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
