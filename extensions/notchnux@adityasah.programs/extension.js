import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

import { NotchNux } from './src/notchnux.js';

export default class NotchNuxExtension extends Extension {
    enable() {
        console.log('NotchNux: Enabling extension...');
        
        // 1. Hide default top bar elements (top left icons, clock, and top right status icons)
        if (Main.panel) {
            if (Main.panel.statusArea && Main.panel.statusArea.dateMenu && Main.panel.statusArea.dateMenu.hide) {
                Main.panel.statusArea.dateMenu.hide();
            }
            if (Main.panel._leftBox && Main.panel._leftBox.hide) {
                Main.panel._leftBox.hide();
            }
            if (Main.panel._rightBox && Main.panel._rightBox.hide) {
                Main.panel._rightBox.hide();
            }
            if (Main.panel._centerBox && Main.panel._centerBox.hide) {
                Main.panel._centerBox.hide();
            }
            Main.panel.set_style('background-color: transparent !important; background: transparent !important; box-shadow: none !important; border: none !important;');
        }

        // 2. Create and mount NotchNux widget
        this._notch = new NotchNux(this);
        Main.layoutManager.addTopChrome(this._notch, { trackFullscreen: false });
    }

    disable() {
        console.log('NotchNux: Disabling extension...');
        
        // 1. Remove and destroy widget
        if (this._notch) {
            Main.layoutManager.removeChrome(this._notch);
            this._notch.destroy();
            this._notch = null;
        }

        // 2. Restore default panel elements
        if (Main.panel) {
            if (Main.panel._leftBox && Main.panel._leftBox.show) {
                Main.panel._leftBox.show();
            }
            if (Main.panel._rightBox && Main.panel._rightBox.show) {
                Main.panel._rightBox.show();
            }
            if (Main.panel._centerBox && Main.panel._centerBox.show) {
                Main.panel._centerBox.show();
            }
            if (Main.panel.statusArea && Main.panel.statusArea.dateMenu && Main.panel.statusArea.dateMenu.show) {
                Main.panel.statusArea.dateMenu.show();
            }
            Main.panel.set_style(null);
        }
    }
}
